package com.example.QEHS

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioTrack
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.nio.ByteBuffer
import java.nio.ByteOrder
import org.devio.flutter.splashscreen.SplashScreen

class MainActivity : FlutterActivity() {
    private val KEY_APP_INSTALLED = "app_installed"

    private val CHANNELName = "com.example.QEHS/audio"
    private var audioThread: AudioThread? = null
    private var assetaudioThread: AssetsAudioThread? = null
    private var isPlaying: Boolean = false
    private var isPlaying2: Boolean = false
    override fun onCreate(savedInstanceState: Bundle?) {
        SplashScreen.show(this, R.style.SplashScreenTheme) // 自定义的闪屏
        super.onCreate(savedInstanceState)
        this.flutterEngine?.let { GeneratedPluginRegistrant.registerWith(it) }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // 注册 MethodChannel
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNELName)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "playAudio" -> {
                    if (!isPlaying) {
                        // 获得flutter传递的参数
                        val leftFilename = call.argument<String>("leftFilename")
                        val rightFilename = call.argument<String>("rightFilename")
                        val doubLeftVol = call.argument<Double>("leftVolume")
                        val doubRightVol = call.argument<Double>("rightVolume")
                        val leftVolume = doubLeftVol?.toFloat() ?: 1.0f
                        val rightVolume = doubRightVol?.toFloat() ?: 1.0f
                        // 如果没有在播放，则开始播放音频
                        // 把参数传入给类的实例audiothread
                        audioThread =
                                AudioThread(
                                        leftFilename,
                                        rightFilename,
                                        leftVolume,
                                        rightVolume,
                                        context
                                )
                        audioThread?.start() // 调用 AudioThread 的 start() 启动线程
                        isPlaying = true
                        result.success("Audio playing started.")
                    } else {
                        result.success("Audio is already playing.")
                        isPlaying = true
                    }
                }
                "toggleAudio" -> {
                    if (isPlaying) {
                        audioThread?.pause()
                        isPlaying = false
                        result.success("Audio playing paused.")
                    }
                }
                "playAudio2" -> {
                    if (!isPlaying2) {
                        // 完成原生端的配置
                        val leftbyteData = call.argument<ByteArray>("leftbyteData")
                        val rightbyteData = call.argument<ByteArray>("rightbyteData")
                        val leftVolume = call.argument<Double>("leftVolume")?.toFloat() ?: 1.0f
                        val rightVolume = call.argument<Double>("rightVolume")?.toFloat() ?: 1.0f
                        assetaudioThread =
                                AssetsAudioThread(
                                        leftbyteData,
                                        rightbyteData,
                                        leftVolume,
                                        rightVolume
                                )
                        assetaudioThread?.start()
                        isPlaying2 = true
                        result.success("Audio2 playing started.")
                    } else {
                        result.success("Audio2 is already playing.")
                        isPlaying2 = true
                    }
                }
                "toggleAudio2" -> {
                    if (isPlaying2) {
                        assetaudioThread?.pause()
                        isPlaying2 = false
                        result.success("Audio playing paused.")
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    companion object {
        private const val TAG = "MainActivity"
    }
}

// 自定义一个音频线程Define a separate audio thread class
private class AudioThread(
        private val leftFilename: String?,
        private val rightFilename: String?,
        private val leftVolume: Float,
        private val rightVolume: Float,
        private val context: Context
) : Thread() {
    private var isPlaying = false // ?
    val leftFile = File(leftFilename) // 通过文件名读取文件
    val rightFile = File(rightFilename)
    private var leftStream: FileInputStream? = null
    private var rightStream: FileInputStream? = null
    private var bothTrack: AudioTrack? = null

    override fun run() {
        // 定义参数
        val sampleRate = 44100
        val channelConfig = AudioFormat.CHANNEL_OUT_STEREO // 双声道
        val audioFormat = AudioFormat.ENCODING_PCM_16BIT // 流模式
        val minbufferSize =
                AudioTrack.getMinBufferSize(
                        sampleRate,
                        channelConfig,
                        audioFormat
                ) // 获取最小缓冲区大小，其值要大于等于接收流的最小缓冲区大小
        val mode = AudioTrack.MODE_STREAM
        // 创建AudioTrack对象
        // 旧版定义：AudioTrack(
        // AudioManager.STREAM_MUSIC,sampleRate,channelConfig,audioFormat,bufferSize,
        // AudioTrack.MODE_STREAM)
        // 可以只用一个AudioTrack即可实现（只需对播放数据进行组合）
        bothTrack =
                AudioTrack.Builder()
                        .setAudioAttributes(
                                AudioAttributes.Builder()
                                        .setUsage(AudioAttributes.USAGE_MEDIA)
                                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                                        .build()
                        )
                        .setAudioFormat(
                                AudioFormat.Builder()
                                        .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                                        .setSampleRate(sampleRate)
                                        .setChannelMask(channelConfig)
                                        .build()
                        )
                        .setBufferSizeInBytes(minbufferSize)
                        .setTransferMode(mode)
                        .build()

        leftStream = FileInputStream(leftFile) // 从文件到FileInputStream类
        rightStream = FileInputStream(rightFile)
        leftStream?.skip(44)
        rightStream?.skip(44) // wav在PWM基础上开头有44byte的信息
        // 定义两个缓冲区（后面可以写入数据）
        // 在Java和Kotlin中，ByteArray类表示字节数组，常用于存储二进制数据，例如音频、图像、视频等
        val leftBufferByte = ByteArray(minbufferSize / 2) // 创建长度为 的一个ByteArray实例，
        val rightBufferByte = ByteArray(minbufferSize / 2) // 得到输入流对象2
        // bothTrack.setPlaybackRate(44100)
        // bothTrack.play()
        // 控制音频分别播放到左右耳
        bothTrack?.setStereoVolume(leftVolume, rightVolume)
        // 从左右声道的音频文件创建对应的 输入流对象
        // 从输入流读取音频数据到字节数组 存到缓冲区leftBufferByte中
        // read(byteArray)：读取字节数组长度的数据，返回实际读取的字节数。
        // 文件输入流的read函数 如果已经到达输入流的末尾，则返回-1
        try {
            /*try-catch-finally 是一种异常处理机制，用于捕获和处理可能抛出异常的代码块，提高代码的可靠性和稳定性。
            没有catch 直接裸放的话  暂停stream会出错*/
            while (leftStream != null && rightStream != null && !isInterrupted) {
                var numOfBytesRd = leftStream!!.read(leftBufferByte) // 读到leftBufferByte中
                if (numOfBytesRd == -1) {
                    break
                }
                numOfBytesRd = rightStream!!.read(rightBufferByte)
                if (numOfBytesRd == -1) {
                    break
                }
                // 整合左右耳读到的字节数组数据，并将其转换为立体声音频数据
                val stereoBufferByte = ByteArray(minbufferSize)
                var stereoBufferByteIndex = 0
                // indices 获取一个数组或者列表的有效索引范围，返回IntRange类型的值，表示从0开始到最后一个元素索引的范围。
                // 在 Kotlin 中，indices 通常和for循环结合，（step 2 应该是每个样本占用2个字节16bit，因此要递增2
                // 表示每隔两个元素遍历一次）
                for (i in leftBufferByte.indices step 2) {
                    stereoBufferByte[stereoBufferByteIndex++] = leftBufferByte[i]
                    stereoBufferByte[stereoBufferByteIndex++] = leftBufferByte[i + 1] // 合并立体声
                    stereoBufferByte[stereoBufferByteIndex++] = rightBufferByte[i]
                    stereoBufferByte[stereoBufferByteIndex++] = rightBufferByte[i + 1]
                }
                bothTrack?.play() // play函数 将playState设置为播放状态（PLAYSTATE_PLAYING）
                // 对于两个左右字节数组中的每一对相邻元素（下标为 i 和 i+1）
                // 将它们的值依次存入 stereoBufferByte 数组中（实现左右声道合并）
                bothTrack?.write(stereoBufferByte, 0, stereoBufferByte.size)
                // 将数据写入播放缓冲区
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
        // finally {
        //     // 关闭输入输出流
        //     leftStream?.close()
        //     rightStream?.close()
        //     bothTrack?.stop()
        //     bothTrack?.release()
        //     isPlaying = false
        //     bothTrack = null // 没有这个会卡退
        // }
    }
    fun pause() {
        isPlaying = false
        bothTrack?.stop() // 一开始是stop
        // 关闭输入输出流
        leftStream?.close()
        rightStream?.close()
        bothTrack = null // 没有这个会卡退
    }
}

// 也封装成线程类
private class AssetsAudioThread(
        leftBytes: ByteArray?,
        rightBytes: ByteArray?,
        leftVolume2: Float,
        rightVolume2: Float
) : Thread() {
    var leftVol = leftVolume2
    var rightVol = rightVolume2
    var leftBytes = leftBytes
    var rightBytes = rightBytes
    private var isPlaying2 = false // ?
    val sampleRate = 44100
    val channelConfig = AudioFormat.CHANNEL_OUT_STEREO // 双声道
    val audioFormat = AudioFormat.ENCODING_PCM_16BIT // 流模式
    val minBufferSize = AudioTrack.getMinBufferSize(sampleRate, channelConfig, audioFormat)
    // val mode = AudioTrack.MODE_STREAM
    val mode = AudioTrack.MODE_STREAM
    private var track: AudioTrack? = null
    override fun run() {
        // 启动 AudioTrack
        track =
                AudioTrack.Builder()
                        .setAudioAttributes(
                                AudioAttributes.Builder()
                                        .setUsage(AudioAttributes.USAGE_MEDIA)
                                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                                        .build()
                        )
                        .setAudioFormat(
                                AudioFormat.Builder()
                                        .setEncoding(audioFormat)
                                        .setSampleRate(sampleRate)
                                        .setChannelMask(channelConfig)
                                        .build()
                        )
                        .setBufferSizeInBytes(minBufferSize)
                        .setTransferMode(mode)
                        .build()
        track?.setStereoVolume(leftVol, rightVol)
        val leftBuffer = ByteBuffer.wrap(leftBytes).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer()
        val rightBuffer = ByteBuffer.wrap(rightBytes).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer()
        val stereoBuffer = ShortArray(minBufferSize / 2)

        try {
            while (leftBuffer.hasRemaining() || rightBuffer.hasRemaining()) {
                var stereoIndex = 0
                while (stereoIndex < stereoBuffer.size) {
                    if (leftBuffer.hasRemaining()) {
                        stereoBuffer[stereoIndex] = leftBuffer.get()
                    } else {
                        stereoBuffer[stereoIndex] = 0
                    }
                    if (rightBuffer.hasRemaining()) {
                        stereoBuffer[stereoIndex + 1] = rightBuffer.get()
                    } else {
                        stereoBuffer[stereoIndex + 1] = 0
                    }
                    stereoIndex += 2 // 关键
                }
                track?.play()
                track?.write(stereoBuffer, 0, stereoBuffer.size, AudioTrack.WRITE_BLOCKING)
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
        track?.stop()
        track?.release()
        isPlaying2 = false
        track = null // 没有这个会卡退
    }

    fun pause() {
        isPlaying2 = false
        track?.stop() // 一开始是stop
        // 关闭输入输出流
        track = null // 没有这个会卡退
    }
}
