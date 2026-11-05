export const FLAME_VERTEX_SHADER = /* glsl */ `
  varying vec2 vUv;
  void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  }
`;

export const FLAME_FRAGMENT_SHADER = /* glsl */ `
  precision mediump float;

  varying vec2 vUv;
  uniform float uTime;
  uniform float uScale;
  uniform float uSpeed;
  uniform float uBurst;
  uniform vec3 uCoreColor;
  uniform vec3 uMidColor;
  uniform vec3 uTipColor;

  float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
  }

  float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
  }

  float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 4; i++) {
      v += a * noise(p);
      p *= 2.02;
      a *= 0.5;
    }
    return v;
  }

  void main() {
    // Normalize UV to x in [-1, 1], y in [0, 1]
    vec2 p = vec2((vUv.x - 0.5) * 2.2, vUv.y);

    // Scale height around base
    float effScale = clamp(uScale + uBurst * 0.22, 0.25, 1.35);
    p.y = p.y / effScale;

    if (p.y < 0.0 || p.y > 1.15) {
      discard;
    }

    float t = uTime * uSpeed;

    // Horizontal turbulence that increases toward the tip
    float n1 = fbm(vec2(p.x * 2.6, p.y * 3.2 - t * 2.4));
    float n2 = fbm(vec2(p.x * 5.0 + 3.1, p.y * 5.5 - t * 3.8));
    float sway = (n1 - 0.5) * 0.55 * pow(p.y, 0.75);
    float xDist = abs(p.x + sway);

    // Teardrop width profile: wider near bottom-mid, tapering to 0 at top
    float widthProfile = sin(clamp(p.y, 0.0, 1.0) * 3.14159265) * (1.0 - 0.45 * p.y);
    widthProfile = max(0.001, widthProfile * 0.72);

    // Base mask + fBm erosion near edges
    float edgeDist = xDist / widthProfile;
    float flameShape = 1.0 - edgeDist - (n2 * 0.38 * p.y);
    float alpha = smoothstep(0.0, 0.38, flameShape);

    // Inner hot core mask
    float coreMask = smoothstep(0.35, 0.88, flameShape * (1.15 - p.y * 0.65));
    float midMask = smoothstep(0.1, 0.55, flameShape);

    vec3 col = mix(uTipColor, uMidColor, midMask);
    col = mix(col, uCoreColor, coreMask);

    // Extra brightness during streak-increase burst
    col += vec3(0.25, 0.18, 0.08) * uBurst;

    // Soft bottom fade
    alpha *= smoothstep(0.0, 0.08, p.y) * (1.0 - smoothstep(0.88, 1.08, p.y));

    if (alpha < 0.01) {
      discard;
    }

    gl_FragColor = vec4(col, alpha);
  }
`;

export const EMBER_VERTEX_SHADER = /* glsl */ `
  attribute float aSeed;
  attribute float aSpeed;
  uniform float uTime;
  uniform float uScale;
  uniform float uBurst;
  varying float vLife;

  void main() {
    float speed = aSpeed * (1.0 + uBurst * 0.6);
    float life = fract(aSeed + uTime * speed * 0.35);
    vLife = life;

    float angle = aSeed * 6.2831853;
    float radius = (0.12 + 0.32 * fract(aSeed * 13.7)) * (1.0 - life * 0.35) * uScale;
    float spiral = uTime * 1.8 + aSeed * 12.0;

    vec3 pos = vec3(
      cos(angle + spiral * 0.3) * radius,
      -0.65 + life * (1.55 * uScale + uBurst * 0.3),
      sin(angle + spiral * 0.3) * radius * 0.3
    );

    vec4 mvPosition = modelViewMatrix * vec4(pos, 1.0);
    gl_Position = projectionMatrix * mvPosition;
    gl_PointSize = (1.0 - life * 0.7) * (12.0 + uBurst * 6.0);
  }
`;

export const EMBER_FRAGMENT_SHADER = /* glsl */ `
  precision mediump float;
  uniform vec3 uColor;
  varying float vLife;

  void main() {
    vec2 coord = gl_PointCoord - vec2(0.5);
    float dist = length(coord);
    if (dist > 0.5) discard;

    float soft = smoothstep(0.5, 0.05, dist);
    float fade = sin(vLife * 3.14159265);
    gl_FragColor = vec4(uColor, soft * fade * 0.9);
  }
`;

export const GLOW_FRAGMENT_SHADER = /* glsl */ `
  precision mediump float;
  varying vec2 vUv;
  uniform vec3 uGlowColor;
  uniform float uGlowIntensity;
  uniform float uTime;

  void main() {
    float d = length(vUv - vec2(0.5));
    float pulse = 0.92 + 0.08 * sin(uTime * 3.2);
    float glow = smoothstep(0.5, 0.0, d) * uGlowIntensity * pulse * 0.55;
    if (glow < 0.01) discard;
    gl_FragColor = vec4(uGlowColor, glow);
  }
`;
