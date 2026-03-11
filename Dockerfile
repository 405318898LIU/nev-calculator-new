# 新能源投资收益计算器 - Docker构建镜像
# 使用方法:
# 1. 把项目复制到本机
# 2. 运行: docker build -t nev-calculator .
# 3. 提取APK: docker create --name temp nev-calculator && docker cp temp:/app/build/app/outputs/flutter-apk/app-release.apk ./ && docker rm temp

FROM ghcr.io/cirruslabs/flutter:3.24.0

WORKDIR /app

# 复制项目文件
COPY . /app/

# 获取依赖
RUN flutter pub get

# 构建Android APK
RUN flutter build apk --release

# 输出路径: /app/build/app/outputs/flutter-apk/app-release.apk
