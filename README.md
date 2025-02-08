# 重庆理工大学学位论文 

## 如何使用

**修改 `thesis.typ` 文件即可**

## 推荐平台

1. 在 VS Code 中安装 [Tinymist Typst](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist) 和 [Typst Preview](https://marketplace.visualstudio.com/items?itemName=mgt19937.typst-preview) 插件。前者负责语法高亮和错误检查等功能，后者负责预览。
3. 用 VS Code 打开生成的目录，打开 `thesis.typ` 文件，并按下 `Ctrl + K V` 进行实时编辑和预览。


## 开发指南

### template 目录（模板目录）

- `thesis.typ` 文件: 你的论文源文件，可以随意更改这个文件的名字，甚至你可以将这个文件在同级目录下复制多份，维持多个版本。
- `thesis.bib` 文件: 用于放置参考文献。
- `logos` 目录: 用于放置logo的文件夹。


### 内部目录

1. `utils` 目录: 包含了模板使用到的各种自定义辅助函数，存放没有外部依赖，且 **不会渲染出页面的函数**。
2. `pages` 目录: 包含了模板用到的各个 **独立页面**，例如封面页、声明页、摘要等，即 **会渲染出不影响其他页面的独立页面的函数**。
3. `layouts` 目录: 布局目录，存放着用于排篇布局的、应用于 `show` 指令的、**横跨多个页面的函数**，例如为了给页脚进行罗马数字编码的前言 `preface` 函数。
  - 主要分成了 `doc` 文稿、`preface` 前言、`mainmatter` 正文与 `appendix` 附录/后记。
4. `lib.typ`:
  - **职责一**: 作为一个统一的对外接口，暴露出内部的 utils 函数。
  - **职责二**: 使用 **函数闭包** 特性，通过 `documentclass` 函数类进行全局信息配置，然后暴露出拥有了全局配置的、具体的 `layouts` 和 `pages` 内部函数。

### 待做清单

- **`格式核查(重点)`**
  - [ ] 对照官网下载的格式参考进行修改，使得至少在视觉上符合论文模板，并首先实现本科学位论文的设计

- **说明文档**
  - [ ] 编写详细的说明文档
- **类型检查**
  - [ ] 应该对所有函数入参进行类型检查，及时报错
- **全局配置**
  - [x] 类似 LaTeX 中的 `documentclass` 的全局信息配置
  - [x] **盲审模式**，将个人信息替换成小黑条，并且隐藏致谢页面，论文提交阶段使用 
  - [x] **双面模式**，会加入空白页，便于打印
  - [x] **自定义字体配置**，可以配置「宋体」、「黑体」与「楷体」等字体对应的具体字体
  - [x] **数学字体配置**：模板不提供配置，用户可以自己使用 `#show math.equation: set text(font: "Fira Math")` 更改
- **模板**
  - [x] 本科生模板
    - [x] 字体测试页
    - [x] 毕业论文封面
    - [x] 课程设计封面
    - [x] 声明页
    - [x] 中文摘要
    - [x] 英文摘要
    - [x] 目录页
    - [x] 插图目录
    - [x] 表格目录
    - [x] 符号表
    - [x] 致谢
  - [x] 研究生模板
    - [x] 封面 
    - [x] 声明页 
    - [x] 摘要
    - [x] 页眉 
    - [ ] 国家图书馆封面
    - [ ] 出版授权书
  - [ ] 博士后模板
- **编号**
  - [x] 前言使用罗马数字编号
  - [x] 附录使用罗马数字编号
  - [x] 表格使用 `1.1` 格式进行编号
  - [x] 数学公式使用 `(1.1)` 格式进行编号
- **环境**
  - [x] 定理环境
  - [x] 化学环境
- **其他文件**
  - [x] 本科生开题报告
  - [x] 研究生开题报告


## 致谢

- 感谢[modern-nju-thesis](https://github.com/nju-lug/modern-nju-thesis)，  [HUST-typst-template](https://github.com/werifu/HUST-typst-template) ， [PKU-typst-template](https://github.com/pku-typst)等Typst中文模板。
