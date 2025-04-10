@echo off
chcp 65001

echo 确保安装了 conda
echo 国内镜像站： https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/
echo 已经安装按任意键继续，未安装请直接关闭...
pause


echo 检查是否存在名为 niku_cosy 的环境...
conda info --envs | findstr /i "niku_cosy" >nul 2>&1
if %errorlevel% neq 0 (
    echo 环境 niku_cosy 不存在，正在创建环境...
    conda create -n niku_cosy -y python=3.10
    if %errorlevel% neq 0 (
        echo 创建环境失败，脚本将退出。
        echo 尝试手动创建: conda create -n niku_cosy -y python=3.10
        echo 换源教程: https://mirrors.tuna.tsinghua.edu.cn/help/anaconda/
        pause
        exit /b
    )
    echo 环境 niku_cosy 创建成功，继续执行脚本...
)

echo Conda 已安装，环境 niku_cosy 存在，继续执行脚本...


echo 开始拉取 Matcha-TTS
mkdir third_party
cd third_party
git clone https://gh-proxy.com/github.com/shivammehta25/Matcha-TTS.git


echo 开始拉取 async_cosyvoice
cd ..
git clone https://gh-proxy.com/github.com/qi-hua/async_cosyvoice

:: 激活环境 niku_cosy
call conda activate niku_cosy
if %errorlevel% neq 0 (
    echo 激活环境 niku_cosy 失败，脚本将退出。
    pause
    exit /b
)

pip install -r win_wheel/win_requirements.txt
if %errorlevel% neq 0 (
    echo 安装 requirements 失败，脚本将退出。
    pause
    exit /b
)

pause
