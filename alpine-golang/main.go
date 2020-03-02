package main

import (
	"log"

	"github.com/gin-gonic/gin"
)

func main() {
	// 创建一个 gin实例,返回一个 *engine 路由引擎
	r := gin.Default()
	// 创建一个GET 方法 的 /hello 的路由
	// func 使用 匿名函数方式
	r.GET("/hello", func(c *gin.Context) {
		// 使用 JSON格式,方式, 状态码为 200
		// gin.H 是返回一个map
		c.JSON(200, gin.H{
			"message": "hello world",
		})
	})
	// 启动 gin 服务
	if err := r.Run(":8888"); err != nil {
		log.Fatal(err.Error())
	}
}

