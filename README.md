# CorsProxy : Go 实现前后端 URL 重定向，完成跨域Cors请求

## 简介

这是一种相对方便的跨域方案，计划在前后端中间加一个类似 Nginx 的 URL 重写功能的代理服务（端口为3500），这个代理将无损传输前后端请求与响应。原理其实是很简单的“根据请求的 `Host` 头部将请求转发到不同的服务”，如果你遇到了后端不愿意处理跨域问题而抛给前端玩家这种事，那么你可以直接使用这个项目，由于采用的是Go来编写，编译后的文件只有6Mb大小，在网络请求上近乎无损。考虑到Nginx需要一定的学习成本，加上安装上手时间消耗大，于是乎就有了这个小项目。你可以随地大小装该项目都没问题，能够解决Web开发阶段的大部分跨域问题。

因为跨域问题只存在于开发阶段，假设你在Windows环境下开发，你可以直接将 `win-proxy`整个文件夹放入你的前端工程文件夹根目录下，并且正确的填入 `win-proxy/config.ini`内前后端地址，每次启动前端项目前鼠标双击 `win-proxy/CorsProxy.exe`；亦或者直接编写一段dev.bat（在下方👇有示例）存放在前端文件夹根目录下，从而更加快速地启动整个前端项目(编写完成后，命令行中直接使用 `./dev.bat` 命令即可启动代理和前端)。

```bat
@echo off

:: Start the main.exe in the background
cd win-proxy
start /b CorsProxy.exe
echo Start the proxy server...
cd ..

:: Run the npm run dev command
echo Starting the frontend development server...
npm run dev

:: Pause the script at the end to keep the command prompt window open
pause
```

同样的，如果你的开发环境是在linux服务器上，也一样可以使用 `linux-proxy`这个文件夹内已编译好的文件，需要通过Xftp上传到服务器前端工程根目录，可在下文找到相关信息。



## 文件说明

> /CorsProxy
> ├── linux-proxy/          # Linux 环境下的打包产物
> │   ├── CorsProxy          # Linux 下的可执行文件
> │   ├── config.ini         # 配置文件
> │   └── proxy.log          # 日志文件
> ├── win-proxy/            # Windows 环境下的打包产物
> │   ├── CorsProxy.exe      # Windows 下的可执行文件
> │   ├── config.ini         # 配置文件
> │   └── proxy.log          # 日志文件
> ├── build_linux.bat       # 打包为Linux 环境下的编译脚本
> ├── build_win.bat         # 打包为Windows 环境下的编译脚本
> ├── config.ini             # 原始配置文件
> ├── go.mod                # 模块依赖文件
> ├── go.sum                # 模块校验文件
> └── main.go                # 跨域程序主要代码



## 构建与运行

### Go版本以及其他依赖

|  Go SDK  | 1.17.6 windows/amd64 |
| :------: | :------------------: |
| 其他依赖 | 可参考go.sum，go.mod |



### Linux 环境

1. 使用 `build_linux.bat` 脚本构建 Linux 环境下的可执行文件：

   ```cmd
   ./build_linux.bat
   ```

   生成的 `CorsProxy` 可执行文件位于 `linux-proxy/` 目录下。

2. 运行 `CorsProxy` 前，确保给予执行权限：

   ```bash
   chmod +x linux-proxy/CorsProxy
   ```

3. 启动代理服务器：

   ```bash
   ./linux-proxy/CorsProxy
   ```



### Windows 环境

1. 使用 `build_win.bat` 脚本构建 Windows 环境下的可执行文件：

   ```cmd
   build_win.bat
   ```

   生成的 `CorsProxy.exe` 可执行文件位于 `win-proxy/` 目录下。

2. 使用鼠标双击 `CorsProxy.exe` 或者在命令行中运行它以启动代理服务器：

   ```cmd
   win-proxy/CorsProxy.exe
   ```



## 配置说明

`config.ini` 文件包含了代理服务器所需的配置信息，包括前端和后端的 URL 地址，需要用户自行添加相关信息。使用 `build_linux.bat` 和 `build_win.bat` 打包脚本后，会额外复制该文件。这里无论是http亦或者是https都是可以实现代理的，不需要额外去做配置SSL。

```ini
[proxy]
frontendURL = http://localhost:5173>前端地址
backendURL = 后端API接口地址
```



## 日志记录

启用代理后，运行日志将被记录在 `proxy.log` 文件中，首次启动代理才会生成该文件。可以查看此文件来获取服务器的运行状态和可能的错误信息。该代理将被挂载到3500端口，请确保该端口占用情况。

```bash
cat proxy.log
```



## 注意

- `linux-proxy` 和 `win-proxy` 文件夹是分别通过 `build_linux.bat` 和 `build_win.bat` 脚本生成的打包产物，如若需要自定义修改原本跨域代码 `main.go`，打包可直接使用 `build_linux.bat` 和 `build_win.bat` 。
- `CorsProxy` 和 `CorsProxy.exe` 分别是 Linux 和 Windows 环境下可直接运行的代理服务器程序。
- 每个打包产物的文件夹内都包含了 `config.ini` 配置文件和 `proxy.log` 日志文件。这里的 `config.ini`需要填写正确的前后端地址。 
- 最后的最后，祝你生活愉快！😀👍