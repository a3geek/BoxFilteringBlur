﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace PostEffects
{
    [AddComponentMenu("")]
    [DisallowMultipleComponent]
    [RequireComponent(typeof(Camera))]
    public class BoxFilteringBlur : MonoBehaviour
    {
        public const string PropDelta = "_Delta";
        public const int MaxIteration = 10;

        [SerializeField]
        private bool validity = true;
        [SerializeField]
        private Material material = null;
        [SerializeField, Range(1, MaxIteration)]
        private int iteration = 3;
        [SerializeField]
        private float downRate = 1f;
        [SerializeField]
        private float upRate = 0.5f;

        private RenderTexture[] rts = new RenderTexture[MaxIteration];


        private void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if(this.validity == false)
            {
                Graphics.Blit(source, destination);
                return;
            }

            var width = source.width;
            var height = source.height;

            var i = 0;
            this.material.SetFloat(PropDelta, this.downRate);

            // Step downsampling.
            for(i = 0; i < this.iteration; i++)
            {
                width /= 2;
                height /= 2;
                if(width < 2 || height < 2)
                {
                    break;
                }

                rts[i] = RenderTexture.GetTemporary(width, height, 0, source.format);
                Graphics.Blit(i == 0 ? source : rts[i - 1], rts[i], this.material);
            }

            this.material.SetFloat(PropDelta, this.upRate);
            // Step upsampling.
            for(i -= 1; i > 0; i--)
            {
                Graphics.Blit(rts[i], rts[i - 1], this.material);
                rts[i].Release();
            }

            Graphics.Blit(rts[0], destination, this.material);
            rts[0].Release();
        }
    }
}
