# build stage
FROM node:lts-alpine as build-stage
# 镜像的元信息,maintainer项目维护者
LABEL maintainer="vuefans@gmail.com"
# 工作目录
WORKDIR /app
# 将git仓库下所有文件拷贝到工作目录
COPY . .
# 安装cnpm
RUN npm install cnpm -g --no-progress --registry=https://registry.npm.taobao.org
# 安装项目依赖并打包
RUN cnpm install --no-progress && cnpm run build

# production stage
# 生产环境基础nginx镜像（上面的镜像已经打包为了静态文件）
FROM nginx:stable-alpine as production-stage
# 使用--from把上面产生的静态文件复制到nginx的运行目录
COPY --from=build-stage /app/dist /usr/share/nginx/html
# nginx容器内部暴露的端口
EXPOSE 80
# 运行的命令
CMD ["nginx", "-g", "daemon off;"]