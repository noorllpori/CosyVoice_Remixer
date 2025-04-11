import requests
import pyaudio
import io

# 配置音频播放
p = pyaudio.PyAudio()
stream = p.open(format=pyaudio.paInt16,
                channels=1,
                rate=25000,
                output=True)

# 准备请求数据
url = "http://127.0.0.1:50000/text-tts"
headers = {"Content-Type": "application/json"}
data = {
    "tts_text": "嗯你好啊。 欢迎使用 CosyVoice API，现在是流式测试。",
    "mode": "zero_shot",
    "seed": 3232,
    "sft_dropdown":"中文女",
    "stream": True,
    "prompt_voice": "./asset/zero_shot_prompt.wav",
    "prompt_text": "希望你以后能够做的比我还好呦。"
}
# data = {
#     "tts_text": "你好，欢迎使用 CosyVoice APi，现在是流式测试。",
#     "mode": "sft",
#     "seed": 42,
#     "sft_dropdown":"中文女",
#     "stream": True
# }

while True:
    # 发送请求并处理流式响应
    try:
        response = requests.post(url, json=data, headers=headers, stream=True)

        if response.status_code == 200:
            # 实时播放音频流
            for chunk in response.iter_content(chunk_size=1024):
                if chunk:
                    stream.write(chunk)
        else:
            print(f"Error: {response.status_code} - {response.text}")

    except requests.exceptions.RequestException as e:
        print(f"Request failed: {e}")

    # finally:
    #     # 清理资源
    #     stream.stop_stream()
    #     stream.close()
    #     p.terminate()