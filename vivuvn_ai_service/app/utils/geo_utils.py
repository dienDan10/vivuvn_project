"""
Geographical utilities for clustering and distance calculation.

This module provides lightweight clustering algorithms for grouping places
by geographical proximity without external dependencies.
"""

import math
from typing import List, Dict, Any, Tuple
import structlog

logger = structlog.get_logger(__name__)


def haversine_distance(lat1: float, lng1: float, lat2: float, lng2: float) -> float:
    """
    Calculate distance in km between two lat/lng points using Haversine formula.

    The Haversine formula accounts for Earth's curvature and provides accurate
    distances for city-level tourism planning.

    Args:
        lat1, lng1: First point coordinates (degrees)
        lat2, lng2: Second point coordinates (degrees)

    Returns:
        Distance in kilometers

    Example:
        >>> haversine_distance(21.028, 105.836, 21.071, 105.819)
        4.82  # km between Văn Miếu and Hồ Tây in Hanoi
    """
    R = 6371  # Earth's radius in km

    # Convert to radians
    lat1_rad, lng1_rad = math.radians(lat1), math.radians(lng1)
    lat2_rad, lng2_rad = math.radians(lat2), math.radians(lng2)

    # Haversine formula
    dlat = lat2_rad - lat1_rad
    dlng = lng2_rad - lng1_rad

    a = math.sin(dlat/2)**2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(dlng/2)**2
    c = 2 * math.asin(math.sqrt(a))

    return R * c


def simple_kmeans_geo(
    places: List[Dict[str, Any]],
    k: int = None,
    max_iterations: int = 10
) -> List[List[Dict[str, Any]]]:
    """
    Simple K-Means clustering for geographical points.

    This lightweight implementation clusters places by geographical proximity
    without requiring external libraries like scikit-learn. Uses K-Means++
    initialization for better centroid selection.

    Args:
        places: List of place dictionaries with metadata containing lat/lng
        k: Number of clusters (auto-determined if None using sqrt(n/2) heuristic)
        max_iterations: Maximum iterations for convergence (default: 10)

    Returns:
        List of clusters, each containing place dictionaries.
        Clusters are sorted by distance from overall center (closest first).
        Empty clusters are removed.

    Algorithm:
        1. Extract coordinates from place metadata
        2. Auto-determine k if not specified (2-5 clusters)
        3. Initialize centroids using k-means++ lite (spread out starting points)
        4. Iterate: assign points to nearest centroid, recalculate centroids
        5. Converge when centroids move < 100m
        6. Sort clusters by distance from center for logical ordering

    Example:
        >>> places = [{'metadata': {'latitude': 21.028, 'longitude': 105.836}}, ...]
        >>> clusters = simple_kmeans_geo(places, k=3)
        >>> print(f"Created {len(clusters)} geographical clusters")
    """
    if not places:
        logger.warning("No places to cluster")
        return []

    # Extract coordinates with validation
    coords = []
    for place in places:
        meta = place.get('metadata', {})
        lat = meta.get('latitude', 0)
        lng = meta.get('longitude', 0)

        # Validate coordinates are in valid range
        if lat and lng and -90 <= lat <= 90 and -180 <= lng <= 180:
            coords.append((lat, lng, place))
        else:
            logger.warning(f"Invalid coordinates for place: {meta.get('name', 'Unknown')}")

    if len(coords) < 2:
        logger.info("Too few valid places for clustering, returning as single cluster")
        return [places]

    # Auto-determine k if not specified
    if k is None:
        # Rule of thumb: sqrt(n/2), clamped between 2-5
        # This typically gives 2-3 clusters for 15-30 places (typical city result)
        k = max(2, min(5, int(math.sqrt(len(coords) / 2))))
        logger.info(f"Auto-determined k={k} clusters for {len(coords)} places")

    # If fewer places than clusters, return individual clusters
    if len(coords) <= k:
        logger.info(f"Fewer places ({len(coords)}) than requested clusters ({k}), returning individual clusters")
        return [[place] for lat, lng, place in coords]

    # Initialize centroids using k-means++ lite
    # Start with first point, then iteratively add farthest point from existing centroids
    centroids = [coords[0][:2]]

    for i in range(k - 1):
        max_dist = 0
        farthest = coords[1][:2]

        for lat, lng, _ in coords:
            # Find minimum distance to any existing centroid
            min_dist_to_centroid = min(
                haversine_distance(lat, lng, c[0], c[1]) for c in centroids
            )
            # Track the point farthest from all centroids
            if min_dist_to_centroid > max_dist:
                max_dist = min_dist_to_centroid
                farthest = (lat, lng)

        centroids.append(farthest)

    logger.info(f"Initialized {k} centroids using k-means++ lite")

    # K-means iterations
    for iteration in range(max_iterations):
        # Assign each point to nearest centroid
        clusters = [[] for _ in range(k)]

        for lat, lng, place in coords:
            # Calculate distance to each centroid
            distances = [haversine_distance(lat, lng, c[0], c[1]) for c in centroids]
            # Assign to closest cluster
            closest_cluster = distances.index(min(distances))
            clusters[closest_cluster].append((lat, lng, place))

        # Recalculate centroids as mean of cluster points
        new_centroids = []
        for cluster_idx, cluster in enumerate(clusters):
            if cluster:
                # Average latitude and longitude
                avg_lat = sum(lat for lat, _, _ in cluster) / len(cluster)
                avg_lng = sum(lng for _, lng, _ in cluster) / len(cluster)
                new_centroids.append((avg_lat, avg_lng))
            else:
                # Keep old centroid if cluster became empty (shouldn't happen often)
                logger.warning(f"Cluster {cluster_idx} became empty at iteration {iteration}")
                new_centroids.append(centroids[cluster_idx])

        # Check for convergence (centroids moved < 100m)
        max_movement = max(
            haversine_distance(old[0], old[1], new[0], new[1])
            for old, new in zip(centroids, new_centroids)
        )

        if max_movement < 0.1:  # 100m threshold
            logger.info(f"K-means converged at iteration {iteration + 1} (max movement: {max_movement*1000:.1f}m)")
            break

        centroids = new_centroids
    else:
        logger.info(f"K-means completed {max_iterations} iterations without full convergence")

    # Convert back to place dicts and remove empty clusters
    result = []
    for cluster in clusters:
        if cluster:
            result.append([place for _, _, place in cluster])

    # Calculate overall center for sorting
    if coords:
        overall_center = (
            sum(lat for lat, _, _ in coords) / len(coords),
            sum(lng for _, lng, _ in coords) / len(coords)
        )

        # Sort clusters by distance from center (closest first)
        # This gives a logical ordering: central areas first, then progressively outward
        result.sort(key=lambda cluster: haversine_distance(
            cluster[0]['metadata']['latitude'],
            cluster[0]['metadata']['longitude'],
            overall_center[0],
            overall_center[1]
        ))

    logger.info(f"Created {len(result)} geographical clusters from {len(coords)} places")
    for i, cluster in enumerate(result):
        logger.debug(f"Cluster {i+1}: {len(cluster)} places")

    return result


def get_cluster_name(
    cluster: List[Dict[str, Any]], 
    index: int, 
    total_clusters: int,
    global_center: Tuple[float, float]
) -> str:
    """
    Generate a descriptive Vietnamese name for a geographical cluster.

    Names are based on actual geographical direction relative to the global center
    of all places, providing accurate directional information.

    Args:
        cluster: List of place dictionaries in the cluster
        index: Zero-based cluster index (0 = closest to center)
        total_clusters: Total number of clusters
        global_center: Tuple of (lat, lng) for the overall center

    Returns:
        Vietnamese name for the cluster (e.g., "Khu vực Đông Bắc (5 địa điểm)")

    Example:
        >>> cluster = [place1, place2, place3]
        >>> global_center = (21.028, 105.836)  # Hanoi center
        >>> get_cluster_name(cluster, 0, 3, global_center)
        "Khu vực Đông Bắc (3 địa điểm, ⭐ 4.2)"
    """
    if not cluster:
        return f"Khu vực {index + 1}"

    # Calculate cluster centroid
    lats = [p.get('metadata', {}).get('latitude', 0) for p in cluster]
    lngs = [p.get('metadata', {}).get('longitude', 0) for p in cluster]
    
    if not any(lats) or not any(lngs):
        return f"Khu vực {index + 1} ({len(cluster)} địa điểm)"
    
    cluster_lat = sum(lats) / len(lats)
    cluster_lng = sum(lngs) / len(lngs)

    # Calculate direction based on position relative to global center
    delta_lat = cluster_lat - global_center[0]
    delta_lng = cluster_lng - global_center[1]

    # Threshold for determining "center" vs directional (≈ 1 km latitude difference)
    threshold = 0.01
    
    if abs(delta_lat) < threshold and abs(delta_lng) < threshold:
        direction = "Trung tâm"
    else:
        # Determine primary direction
        if abs(delta_lat) >= abs(delta_lng):
            # North-South dominant
            primary = "Bắc" if delta_lat > 0 else "Nam"
            
            # Add secondary direction if significant
            if abs(delta_lng) >= threshold:
                secondary = "Đông" if delta_lng > 0 else "Tây"
                direction = f"{secondary} {primary}"
            else:
                direction = primary
        else:
            # East-West dominant
            primary = "Đông" if delta_lng > 0 else "Tây"
            
            # Add secondary direction if significant
            if abs(delta_lat) >= threshold:
                secondary = "Bắc" if delta_lat > 0 else "Nam"
                direction = f"{primary} {secondary}"
            else:
                direction = primary

    # Calculate average rating for cluster quality hint
    ratings = [p.get('metadata', {}).get('rating', 0) for p in cluster if p.get('metadata', {}).get('rating', 0) > 0]
    avg_rating = sum(ratings) / len(ratings) if ratings else 0

    # Format cluster name with size
    name = f"Khu vực {direction} ({len(cluster)} địa điểm"

    # Add rating hint if available
    if avg_rating > 0:
        name += f", ⭐ {avg_rating:.1f}"

    name += ")"

    return name


def calculate_cluster_stats(cluster: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    Calculate statistics for a geographical cluster.

    Args:
        cluster: List of place dictionaries

    Returns:
        Dictionary with cluster statistics:
        - center_lat, center_lng: Centroid coordinates
        - avg_rating: Average rating of places
        - radius_km: Maximum distance from centroid to any place
        - place_count: Number of places

    Example:
        >>> stats = calculate_cluster_stats(cluster)
        >>> print(f"Cluster center: ({stats['center_lat']:.3f}, {stats['center_lng']:.3f})")
        >>> print(f"Radius: {stats['radius_km']:.1f}km")
    """
    if not cluster:
        return {
            'center_lat': 0,
            'center_lng': 0,
            'avg_rating': 0,
            'radius_km': 0,
            'place_count': 0
        }

    # Calculate centroid
    lats = [p.get('metadata', {}).get('latitude', 0) for p in cluster]
    lngs = [p.get('metadata', {}).get('longitude', 0) for p in cluster]

    center_lat = sum(lats) / len(lats)
    center_lng = sum(lngs) / len(lngs)

    # Calculate radius (max distance from center)
    max_distance = 0
    for lat, lng in zip(lats, lngs):
        dist = haversine_distance(lat, lng, center_lat, center_lng)
        max_distance = max(max_distance, dist)

    # Calculate average rating
    ratings = [p.get('metadata', {}).get('rating', 0) for p in cluster]
    avg_rating = sum(r for r in ratings if r) / len([r for r in ratings if r]) if any(ratings) else 0

    return {
        'center_lat': center_lat,
        'center_lng': center_lng,
        'avg_rating': avg_rating,
        'radius_km': max_distance,
        'place_count': len(cluster)
    }


__all__ = [
    'haversine_distance',
    'simple_kmeans_geo',
    'get_cluster_name',
    'calculate_cluster_stats'
]
