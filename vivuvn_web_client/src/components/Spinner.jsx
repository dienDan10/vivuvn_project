import styled, { keyframes } from "styled-components";

// Animation for rotation
const rotate = keyframes`
  to {
    transform: rotate(1turn);
  }
`;

// Spinner style
const StyledSpinner = styled.div`
  width: ${({ size }) => size};
  height: ${({ size }) => size};
  border-radius: 50%;
  background: conic-gradient(#0000 10%, #4e73df);
  -webkit-mask: radial-gradient(farthest-side, #0000 calc(100% - 4px), #000 0);
  animation: ${rotate} 1s infinite linear;
`;

// Fullscreen center wrapper for large spinner
const FullPageWrapper = styled.div`
  width: 100vw;
  height: 100vh;
  background: rgba(255, 255, 255, 0.6); /* Optional dimming background */
  display: flex;
  justify-content: center;
  margin-top: 10rem;
  z-index: 9999;
`;

// Spinner components
export const SpinnerSmall = () => <StyledSpinner size="25px" />;
export const SpinnerMedium = () => <StyledSpinner size="50px" />;
export const SpinnerLarge = () => (
  <FullPageWrapper>
    <StyledSpinner size="100px" />
  </FullPageWrapper>
);
