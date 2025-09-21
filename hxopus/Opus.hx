package hxopus;

import haxe.io.BytesData;
import haxe.io.Bytes;
#if openfl
import openfl.media.Sound;
import openfl.utils.Assets;
import openfl.utils.ByteArray;
#end

@:buildXml("<include name='${haxelib:hxopus}/build.xml' />")
@:include("hxopus.hpp")
extern class Opus {
	@:native("hxopus_to_bytes")
	extern static function hxopus_to_bytes(encodedBytes:BytesData):BytesData;

	/**
	 * Decodes the audio data and returns it as bytes.
	 * @param encodedBytes 
	 * @return BytesData
	 */
	public static inline function getDecodedBytes(encodedBytes:Bytes):BytesData {
		#if cpp
		return hxopus_to_bytes(encodedBytes.getData());
		#else
		throw "Opus audio decoding is only supported on C++ targets.";
		#end
	}

	#if openfl
	/**
	 * Returns a new OpenFL `Sound` object.
	 * @param bytes The raw bytes to decode.
	 * @return Sound
	 */
	public overload extern inline static function toOpenFL(bytes:Bytes):Sound {
		return returnSound(Bytes.ofData(getDecodedBytes(bytes)));
	}

	/**
	 * Returns a new OpenFL `Sound` object.
	 * @param file The name of the file to load.
	 * @return Sound
	 */
	public overload extern inline static function toOpenFL(file:String):Sound {
		return returnSound(Bytes.ofData(getDecodedBytes(Assets.getBytes(file))));
	}

	private inline static function returnSound(frames:Bytes):Sound {
		var sound:Sound = new Sound();
		// 4 because 2 channels (stereo) times 2 bytes per pcm frame (short16)
		var frameCount:Int = Math.floor(frames.length / 4);
		sound.loadPCMFromByteArray(ByteArray.fromBytes(frames), frameCount, "short", true, 48000);
		return sound;
	}
	#end
}
