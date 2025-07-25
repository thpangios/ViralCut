import React from 'react';
import {
  AbsoluteFill,
  Video,
  interpolate,
  useCurrentFrame,
  useVideoConfig,
  Sequence
} from 'remotion';

export const ViralEdit = ({
  videoUrl,
  effects,
  timestamp
}) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  return (
    <AbsoluteFill style={{ backgroundColor: 'black' }}>
      
      {/* Main video clip */}
      <Video 
        src={videoUrl}
        startFrom={timestamp * fps} // Start at the identified moment
        style={{
          width: '100%',
          height: '100%',
          objectFit: 'cover'
        }}
      />

      {/* Zoom punch effect */}
      {effects.includes('zoom_punch') && (
        <AbsoluteFill style={{
          transform: `scale(${interpolate(
            frame, 
            [30, 40], // Zoom happens between frame 30-40
            [1, 1.5],
            { extrapolateRight: 'clamp' }
          )})`,
          transformOrigin: 'center'
        }}>
          
          {/* Text overlay with animation */}
          <div style={{
            position: 'absolute',
            top: '20%',
            left: '50%',
            transform: 'translateX(-50%)',
            fontSize: '60px',
            fontWeight: 'bold',
            color: 'white',
            textShadow: '2px 2px 4px rgba(0,0,0,0.8)',
            opacity: interpolate(frame, [25, 35], [0, 1])
          }}>
            WOW! 🔥
          </div>
        </AbsoluteFill>
      )}

      {/* Shake effect */}
      {effects.includes('shake') && (
        <AbsoluteFill style={{
          transform: `translate(${
            Math.sin(frame * 0.5) * (frame > 20 && frame < 50 ? 5 : 0)
          }px, ${
            Math.cos(frame * 0.7) * (frame > 20 && frame < 50 ? 3 : 0)
          }px)`
        }} />
      )}

    </AbsoluteFill>
  );
};
