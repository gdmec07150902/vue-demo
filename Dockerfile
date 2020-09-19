FROM node:lts-alpine as build-stage
COPY ./ /app
WORKDIR /app
# 安装cnpm
RUN npm install cnpm -g --no-progress --registry=https://registry.npm.taobao.org
# 安装项目依赖并打包
RUN cnpm install && cnpm run build

FROM nginx
RUN mkdir /app
COPY --from=0 /app/dist /app
COPY nginx.conf /etc/nginx/nginx.conf