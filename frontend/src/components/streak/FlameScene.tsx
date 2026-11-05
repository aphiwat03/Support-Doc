'use client';

import React, { useEffect, useRef, useState } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import * as THREE from 'three';
import { FlameTierConfig } from './flameTier';
import {
  FLAME_VERTEX_SHADER,
  FLAME_FRAGMENT_SHADER,
  EMBER_VERTEX_SHADER,
  EMBER_FRAGMENT_SHADER,
  GLOW_FRAGMENT_SHADER,
} from './flameShaders';

interface FlameSceneProps {
  days: number;
  tier: FlameTierConfig;
}

const MAX_EMBERS = 48;

interface SceneResources {
  planeGeometry: THREE.PlaneGeometry;
  glowGeometry: THREE.PlaneGeometry;
  emberGeometry: THREE.BufferGeometry;
  glowMaterial: THREE.ShaderMaterial;
  flameMaterial: THREE.ShaderMaterial;
  emberMaterial: THREE.ShaderMaterial;
}

function createSceneResources(init: FlameTierConfig): SceneResources {
  const glowMaterial = new THREE.ShaderMaterial({
    vertexShader: FLAME_VERTEX_SHADER,
    fragmentShader: GLOW_FRAGMENT_SHADER,
    transparent: true,
    depthWrite: false,
    blending: THREE.AdditiveBlending,
    uniforms: {
      uTime: { value: 0 },
      uGlowColor: { value: new THREE.Vector3(...init.midColor) },
      uGlowIntensity: { value: init.glowIntensity },
    },
  });

  const flameMaterial = new THREE.ShaderMaterial({
    vertexShader: FLAME_VERTEX_SHADER,
    fragmentShader: FLAME_FRAGMENT_SHADER,
    transparent: true,
    depthWrite: false,
    blending: THREE.AdditiveBlending,
    uniforms: {
      uTime: { value: 0 },
      uScale: { value: init.scale },
      uSpeed: { value: init.speed },
      uBurst: { value: 0 },
      uCoreColor: { value: new THREE.Vector3(...init.coreColor) },
      uMidColor: { value: new THREE.Vector3(...init.midColor) },
      uTipColor: { value: new THREE.Vector3(...init.tipColor) },
    },
  });

  const emberGeometry = new THREE.BufferGeometry();
  const positions = new Float32Array(MAX_EMBERS * 3);
  const seeds = new Float32Array(MAX_EMBERS);
  const speeds = new Float32Array(MAX_EMBERS);

  for (let i = 0; i < MAX_EMBERS; i++) {
    positions[i * 3] = 0;
    positions[i * 3 + 1] = 0;
    positions[i * 3 + 2] = 0;
    seeds[i] = (i + 0.5) / MAX_EMBERS;
    speeds[i] = 0.65 + ((i * 7) % 11) * 0.08;
  }

  emberGeometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
  emberGeometry.setAttribute('aSeed', new THREE.BufferAttribute(seeds, 1));
  emberGeometry.setAttribute('aSpeed', new THREE.BufferAttribute(speeds, 1));

  const emberMaterial = new THREE.ShaderMaterial({
    vertexShader: EMBER_VERTEX_SHADER,
    fragmentShader: EMBER_FRAGMENT_SHADER,
    transparent: true,
    depthWrite: false,
    blending: THREE.AdditiveBlending,
    uniforms: {
      uTime: { value: 0 },
      uScale: { value: init.scale },
      uBurst: { value: 0 },
      uColor: { value: new THREE.Vector3(...init.coreColor) },
    },
  });

  const planeGeometry = new THREE.PlaneGeometry(1.85, 2.05, 1, 1);
  const glowGeometry = new THREE.PlaneGeometry(2.3, 2.3, 1, 1);

  return {
    planeGeometry,
    glowGeometry,
    emberGeometry,
    glowMaterial,
    flameMaterial,
    emberMaterial,
  };
}

function FlameMeshes({
  days,
  tier,
  paused,
}: {
  days: number;
  tier: FlameTierConfig;
  paused: boolean;
}) {
  const [resources] = useState<SceneResources>(() => createSceneResources(tier));
  const resourcesRef = useRef<SceneResources>(resources);

  const prevDaysRef = useRef<number>(days);
  const burstRef = useRef<number>(0);
  const lowFpsFramesRef = useRef<number>(0);
  const [reducedEmbers, setReducedEmbers] = useState(false);

  // Trigger burst when streak increases in the same session
  useEffect(() => {
    if (days > prevDaysRef.current && prevDaysRef.current >= 0) {
      burstRef.current = 1.0;
    }
    prevDaysRef.current = days;
  }, [days]);

  // Update drawRange when tier or adaptive quality changes
  useEffect(() => {
    const count = reducedEmbers
      ? Math.floor(tier.emberCount * 0.5)
      : tier.emberCount;
    resourcesRef.current.emberGeometry.setDrawRange(
      0,
      Math.min(MAX_EMBERS, Math.max(0, count))
    );
  }, [tier.emberCount, reducedEmbers]);

  // Dispose all geometries & materials on unmount to prevent memory leaks
  useEffect(() => {
    const res = resourcesRef.current;
    return () => {
      res.planeGeometry.dispose();
      res.glowGeometry.dispose();
      res.emberGeometry.dispose();
      res.flameMaterial.dispose();
      res.glowMaterial.dispose();
      res.emberMaterial.dispose();
    };
  }, []);

  useFrame((_, delta) => {
    if (paused) return;

    const { flameMaterial: fMat, glowMaterial: gMat, emberMaterial: eMat } =
      resourcesRef.current;

    const dt = Math.min(delta, 0.1);

    // Adaptive FPS check: if frame time > 33ms (< 30 FPS) for 90 consecutive frames (~3s), halve embers
    if (delta > 0.033 && !reducedEmbers) {
      lowFpsFramesRef.current += 1;
      if (lowFpsFramesRef.current > 90) {
        setReducedEmbers(true);
      }
    } else {
      lowFpsFramesRef.current = Math.max(0, lowFpsFramesRef.current - 1);
    }

    // Smoothly decay burst
    if (burstRef.current > 0) {
      burstRef.current = Math.max(0, burstRef.current - dt * 1.15);
    }

    const lerpFactor = Math.min(1, dt * 4.5);

    fMat.uniforms.uTime.value += dt;
    fMat.uniforms.uScale.value = THREE.MathUtils.lerp(
      fMat.uniforms.uScale.value,
      tier.scale,
      lerpFactor
    );
    fMat.uniforms.uSpeed.value = THREE.MathUtils.lerp(
      fMat.uniforms.uSpeed.value,
      tier.speed,
      lerpFactor
    );
    fMat.uniforms.uBurst.value = burstRef.current;

    fMat.uniforms.uCoreColor.value.lerp(
      new THREE.Vector3(...tier.coreColor),
      lerpFactor
    );
    fMat.uniforms.uMidColor.value.lerp(
      new THREE.Vector3(...tier.midColor),
      lerpFactor
    );
    fMat.uniforms.uTipColor.value.lerp(
      new THREE.Vector3(...tier.tipColor),
      lerpFactor
    );

    gMat.uniforms.uTime.value += dt;
    gMat.uniforms.uGlowIntensity.value = THREE.MathUtils.lerp(
      gMat.uniforms.uGlowIntensity.value,
      tier.glowIntensity + burstRef.current * 0.25,
      lerpFactor
    );
    gMat.uniforms.uGlowColor.value.lerp(
      new THREE.Vector3(...tier.midColor),
      lerpFactor
    );

    eMat.uniforms.uTime.value += dt;
    eMat.uniforms.uScale.value = fMat.uniforms.uScale.value;
    eMat.uniforms.uBurst.value = burstRef.current;
    eMat.uniforms.uColor.value.lerp(
      new THREE.Vector3(...tier.coreColor),
      lerpFactor
    );
  });

  return (
    <group position={[0, -0.05, 0]}>
      {/* Layer 3: Soft Additive Glow */}
      <mesh
        geometry={resources.glowGeometry}
        material={resources.glowMaterial}
        position={[0, -0.05, -0.05]}
      />
      {/* Layer 1: Procedural fBm Shader Flame Billboard */}
      <mesh
        geometry={resources.planeGeometry}
        material={resources.flameMaterial}
        position={[0, 0.0, 0]}
      />
      {/* Layer 2: Rising GPU Embers */}
      <points
        geometry={resources.emberGeometry}
        material={resources.emberMaterial}
        position={[0, 0.0, 0.05]}
      />
    </group>
  );
}

export default function FlameScene({ days, tier }: FlameSceneProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const [isVisible, setIsVisible] = useState(true);
  const [isTabActive, setIsTabActive] = useState(true);

  useEffect(() => {
    const handleVisibility = () => {
      setIsTabActive(!document.hidden);
    };
    document.addEventListener('visibilitychange', handleVisibility);
    return () => document.removeEventListener('visibilitychange', handleVisibility);
  }, []);

  useEffect(() => {
    const el = containerRef.current;
    if (!el || typeof IntersectionObserver === 'undefined') return;

    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0]) {
          setIsVisible(entries[0].isIntersecting);
        }
      },
      { threshold: 0.05 }
    );
    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  const paused = !isVisible || !isTabActive;

  return (
    <div ref={containerRef} className="w-full h-full" aria-hidden="true">
      <Canvas
        dpr={[1, 1.5]}
        frameloop={paused ? 'never' : 'always'}
        camera={{ position: [0, 0, 2.2], fov: 45 }}
        gl={{
          alpha: true,
          antialias: true,
          powerPreference: 'high-performance',
        }}
      >
        <FlameMeshes days={days} tier={tier} paused={paused} />
      </Canvas>
    </div>
  );
}
