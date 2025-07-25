import { registerRoot } from 'remotion';
import { ViralEdit } from './ViralEdit';

registerRoot(() => {
  return (
    <>
      <Composition
        id="ViralEdit"
        component={ViralEdit}
        durationInFrames={300} // 10 seconds at 30fps
        fps={30}
        width={1080}
        height={1920} // 9:16 aspect ratio for TikTok
      />
    </>
  );
});
