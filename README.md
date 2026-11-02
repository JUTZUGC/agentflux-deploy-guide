# AgentFlux 一键部署指南

> 第三方部署指南 · 非 AgentFlux 官方仓库。官方项目：[davemessew/AgentFlux](https://github.com/davemessew/AgentFlux)
> 内容来自官方文档（2026-11-02）。项目迭代快，请以[官方文档](https://github.com/davemessew/AgentFlux/blob/main/docs/installation.md)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 工作流不该只能画在别人的云上：画布、数据源与 agent 全部跑在自己机器，文件不出门。

⚠️ 需要 Docker 与 Linux 容器（镜像只有 linux/amd64，Apple Silicon 上会走模拟，速度较慢）。安装包内含应用镜像与一个本地语音服务，磁盘与内存各留几 GB。模型要单独接一个服务端，Docker 里访问宿主机模型要用 `host.docker.internal`。默认端口 4310。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/agentflux-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会检查 Docker，下载离线镜像与 compose 文件并校验，加载镜像后起两个容器，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Docker；未安装时按对话提示安装。）

4. **打开管理面板**
   浏览器访问 [http://localhost:4310](http://localhost:4310)，按官方引导完成初始化配置。

## AgentFlux 是什么？

AgentFlux 是开源的把工作流、数据源与自主 agent 画在一块画布上，导入文件、跑任务，结果都留在本地（协议：Apache-2.0，<img src="https://img.shields.io/github/stars/davemessew/AgentFlux?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

可视化 agent 工作流平台：在画布上连线编排任务，接入文件与数据源，运行自主 agent，内置语音转写服务，数据与结果都落在本地卷里。

- 可视化画布：拖拽连线搭工作流
- 自主 agent：按目标自己决定步骤
- 本地优先：文件、结果与模型连接都在自己机器
- 离线可装：镜像随包分发，装完不依赖registry
- 内置语音服务：附 Whisper base 转写
- Apache-2.0，可商用可二开

（来源：[官方仓库](https://github.com/davemessew/AgentFlux)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 236 stars 10 月新项目 | 名称搜索仅 12 条结果 |
| 可视化画布编排工作流 | — |
| 离线镜像 | 安装后不依赖 registry |
| 数据与结果都在本地卷 | — |
| 内置语音转写服务 | — |
| Apache-2.0 | 可商用可二开 |

| 需要注意 | 说明 |
|---|---|
| 镜像只支持 linux/amd64 | — |
| 需要自备模型服务 | — |
| 磁盘与内存占用偏大 | — |
| 语音模型只有 base 档 | — |
| 项目很新 | 版本间数据可能不兼容 |

> 以上基于官方文档与社区反馈整理（2026-11-02），以官方最新文档为准。

## 快速部署（官方方式）

```bash
mkdir -p agentflux && cd agentflux
curl -fL -o agentflux-0.3.0-linux-amd64.tar.gz https://github.com/davemessew/AgentFlux/releases/download/v0.3.0/agentflux-0.3.0-linux-amd64.tar.gz
curl -fL -o compose.yaml https://github.com/davemessew/AgentFlux/releases/download/v0.3.0/compose.yaml
curl -fL -o SHA256SUMS.txt https://github.com/davemessew/AgentFlux/releases/download/v0.3.0/SHA256SUMS.txt
sha256sum --check --ignore-missing SHA256SUMS.txt
docker load -i agentflux-0.3.0-linux-amd64.tar.gz
docker compose up -d --wait
echo "已启动：默认端口 4310，两个服务都 healthy 后再打开"
```

启动后浏览器访问 [http://localhost:4310](http://localhost:4310)（管理面板）。（来源：[https://github.com/davemessew/AgentFlux/releases/download/v0.3.0/INSTALL.md](https://github.com/davemessew/AgentFlux/releases/download/v0.3.0/INSTALL.md)）

## 验证状态

| 场景 | 状态 |
|---|---|
| INSTALL.md 确认四步安装、4310 端口与两个数据卷 | 已核对 2026-11-02 |
| Release v0.3.0 的 SHA256SUMS.txt 已下载核对（linux-amd64 镜像包） | 已核对 2026-11-02 |
| 未实测加载镜像与启动 | 说明 2026-11-02 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-11-02 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-11-02 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

项目本身不含 MCP；本仓库的 MCP 只提供部署步骤、端口与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-11-02）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\agentflux-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 安装四步

1. 下载镜像包、`compose.yaml` 与 `SHA256SUMS.txt` 到同一目录
2. 校验：`sha256sum --check --ignore-missing SHA256SUMS.txt`
3. 加载镜像：`docker load -i agentflux-0.3.0-linux-amd64.tar.gz`
4. 启动：`docker compose up -d --wait`

两个服务都显示 `healthy` 后，打开[本地控制台](http://localhost:4310)。

## 接模型

在「Models」里添加模型连接，地址按部署方式区分：

| 部署方式 | 模型地址 |
|---|---|
| Docker 内 | `http://host.docker.internal:11434` |
| 原生安装 | `http://127.0.0.1:11434` |

## 数据与升级

| 卷 | 内容 |
|---|---|
| `agentflux-data` | 应用数据、报告与密钥 |
| `agentflux-models` | 语音模型缓存 |

升级前先停服务并备份整个数据卷（含 `.vault-key`）。`docker compose down` 保留数据，**加 `-v` 会删掉**。

## 注意

- 镜像只有 linux/amd64，ARM 设备走模拟会更慢
- 端口 4310 被占时改 compose 的映射
- 发布包用 `pull_policy: never`，必须先用 `docker load` 导入
- 容器以 UID 1000 运行，挂载目录注意权限
- 语音服务只带 base 模型，长音频慢

## 常见坑

- compose 启动失败：确认已先 docker load 导入镜像
- 4310 打不开：等两个容器都 healthy，首次启动较慢
- 模型连不上：Docker 里要用 host.docker.internal 而不是 127.0.0.1
- Apple Silicon 上很慢：走的是 amd64 模拟
- 升级后数据打不开：先备份整卷，旧版本可能读不了新数据
- 误删数据：别用 docker compose down -v
- 挂载目录没权限：容器是 UID 1000，调整宿主目录属主

## 免责声明

本仓库为第三方指南，与 AgentFlux 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-11-02），项目迭代快，请以[官方文档](https://github.com/davemessew/AgentFlux/blob/main/docs/installation.md)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
