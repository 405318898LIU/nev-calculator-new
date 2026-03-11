#!/bin/bash
# 构建脚本 - 在macOS/Linux上运行
# 前提: 已安装Docker

echo "═══════════════════════════════════════════"
echo "  新能源投资收益计算器 - Docker构建脚本"
echo "═══════════════════════════════════════════"
echo ""

# 检查Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker未安装，请先安装Docker"
    exit 1
fi

echo "✓ Docker已安装"
echo ""

# 进入项目目录
cd "$(dirname "$0")"

echo "【步骤1/4】构建Docker镜像..."
docker build -t nev-calculator:latest .

if [ $? -ne 0 ]; then
    echo "❌ Docker构建失败"
    exit 1
fi

echo "✓ Docker镜像构建成功"
echo ""

echo "【步骤2/4】创建临时容器..."
docker create --name temp-nev-calculator nev-calculator:latest

echo "【步骤3/4】提取APK文件..."
docker cp temp-nev-calculator:/app/build/app/outputs/flutter-apk/app-release.apk ./nev_investment_calculator.apk

echo "【步骤4/4】清理临时容器..."
docker rm temp-nev-calculator

echo ""
echo "═══════════════════════════════════════════"
echo "  ✅ 构建成功!"
echo "  APK文件: ./nev_investment_calculator.apk"
echo "═══════════════════════════════════════════"
