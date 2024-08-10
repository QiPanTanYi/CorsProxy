package main

import (
	"github.com/go-ini/ini"
	_ "io/ioutil"
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"
	"os"
)

// ProxyConfig 代表代理服务器的配置结构体
type ProxyConfig struct {
	FrontendURL string
	BackendURL  string
}

func main() {
	// 打开日志文件
	logFile, err := os.OpenFile("proxy.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("无法打开日志文件: %v", err)
	}
	defer logFile.Close()

	// 设置日志输出为 logFile
	log.SetOutput(logFile)

	// 加载配置文件
	cfg, err := ini.Load("config.ini")
	if err != nil {
		log.Fatalf("配置文件读取错误: %v", err)
	}

	// 从配置文件中获取前端和后端的 URL
	var proxyConfig ProxyConfig
	proxyConfig.FrontendURL = cfg.Section("proxy").Key("frontendURL").String()
	proxyConfig.BackendURL = cfg.Section("proxy").Key("backendURL").String()

	// 解析 URL
	frontendURL, err := url.Parse(proxyConfig.FrontendURL)
	if err != nil {
		log.Fatalf("无效的前端 URL: %v", err)
	}
	backendURL, err := url.Parse(proxyConfig.BackendURL)
	if err != nil {
		log.Fatalf("无效的后端 URL: %v", err)
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// 根据请求的 Host 头部来判断请求的目标
		if r.Host == frontendURL.Host {
			// 如果请求是前端资源，转发到前端服务器
			httputil.NewSingleHostReverseProxy(frontendURL).ServeHTTP(w, r)
		} else {
			// 其他请求转发到后端服务器
			httputil.NewSingleHostReverseProxy(backendURL).ServeHTTP(w, r)
		}
	})

	// 启动服务器监听 3500 端口
	log.Println("Starting proxy server on port 3500...")
	if err := http.ListenAndServe(":3500", nil); err != nil {
		log.Fatal("ListenAndServe error: ", err)
	}
}
