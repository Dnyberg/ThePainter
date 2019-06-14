using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class SC_PlayerMovementSounds : MonoBehaviour
{
	Player3DController controller;

	public AudioSource walkSound1;
	public AudioSource walkSound1Extra;
	public AudioSource walkSound2;
	public AudioSource jump;
	public AudioSource land;

	float loopInterval = 0.4f;
	float loop2Delay = 0.2f;
	float randPitchRange = 0.25f;

	bool previousFrameIsJumping = false;
	bool currentFrameIsJumping = false;
	bool previousFrameIsWalking = false;
	bool currentFrameIsWalking = false;
	bool previousFrameIsGrounded = false;
	bool currentFrameIsGrounded = false;

	bool walkingSoundPlaying = false;

	private void Start()
	{
		controller = GetComponentInParent<Player3DController>();
	}

	private void Update()
	{
		
		previousFrameIsJumping = currentFrameIsJumping ;
		currentFrameIsJumping = controller.isJumping;

		previousFrameIsGrounded = currentFrameIsGrounded;
		currentFrameIsGrounded = controller.controller.isGrounded;

		previousFrameIsWalking = currentFrameIsWalking;
		currentFrameIsWalking = Mathf.Abs(controller.velocity) >= 0.01f && !currentFrameIsJumping && controller.controller.isGrounded;

		if (!previousFrameIsJumping && currentFrameIsJumping)
		{
			PlayJumpSound();
		}
		else if ((previousFrameIsJumping && !currentFrameIsJumping) || (!previousFrameIsGrounded && currentFrameIsGrounded))
		{
			PlayLandSound();
		}

		if (currentFrameIsWalking && !previousFrameIsWalking)
		{
			PlayWalkSound();
		}
		else if (!currentFrameIsWalking && previousFrameIsWalking)
		{
			StopWalkSound();

		}
	}

	public void PlayWalkSound()
	{
		if (walkingSoundPlaying) return;

		walkingSoundPlaying = true;
		CancelInvoke("WalkSoundLoop");
		CancelInvoke("PlayWalkSound2");

		WalkSoundLoop();
		walkSound1.Stop();
		walkSound1Extra.Stop();
		walkSound2.Stop();

	}

	private void WalkSoundLoop()
	{
		if (!walkingSoundPlaying) return;

		walkSound1.Stop();
		walkSound1Extra.Stop();
		walkSound2.Stop();

		walkSound1.pitch = Random.Range(1.5f - randPitchRange, 1.5f + randPitchRange);
		walkSound1Extra.pitch = Random.Range(1f - randPitchRange, 1f + randPitchRange);
		walkSound2.pitch = Random.Range(1.5f - randPitchRange, 1.5f + randPitchRange);
		walkSound1.Play();
		walkSound1Extra.Play();
		Invoke("PlayWalkSound2", loop2Delay);

		Invoke("WalkSoundLoop", loopInterval);
	}

	private void PlayWalkSound2()
	{
		if (!walkingSoundPlaying) return;
		walkSound2.Play();
	}


	public void StopWalkSound()
	{
		walkingSoundPlaying = false;
	}



	public void PlayJumpSound()
	{
		jump.pitch = Random.Range(1f - randPitchRange, 1f + randPitchRange);
		jump.Play();
	}

	public void PlayLandSound()
	{
		land.pitch = Random.Range(1f - randPitchRange, 1f + randPitchRange);
		land.Play();


	}


}
