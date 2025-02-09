// Authors: csimide, OrangeX4
// Tested only on GB-7714-2015-Numeric


#let bilingual-bibliography(

  bibliography: none,
  title: "参考文献",
  full: false,
  style: "gb-7714-2015-numeric",
  mapping: (:),

  // 用于控制多位译者时表现为 `et al. tran`(false) 还是 `et al., tran`(true)
  extra-comma-before-et-al-trans: false,

  // 如果使用的 CSL 中，英文姓名中会出现逗号，请设置为 true
  allow-comma-in-name: false,

  // 控制是否为双面打印模式
  need2page: true,

) = {

  assert(bibliography != none, message: "请传入带有 source 的 bibliography 函数。")

  // 定义中英文映射表
  mapping = (
    "卷": "Vol.",
    "册": "Bk.",
  ) + mapping

  // 辅助函数：将内容转换为字符串
  let to-string(content) = {
    if content.has("text") {
      content.text
    } else if content.has("children") {
      content.children.map(to-string).join("")
    } else if content.has("child") {
      to-string(content.child)
    } else if content.has("body") {
      to-string(content.body)
    } else if content == [ ] {
      " "
    }
  }

  // 处理文本的核心函数
  let process-text(ittext) = {
    // 判断是否为中文文献
    let pureittext = ittext.replace(regex("[等卷册和版本章期页篇译间者(不详)]"), "")
    if pureittext.find(regex("\p{sc=Hani}{2,}")) != none {
      return ittext
    }

    // 处理非中文文献
    let reptext = ittext

    // 处理卷册信息
    reptext = reptext.replace(
      regex("(第\s?)?\d+\s?[卷册]"),
      itt => {
        if itt.text.contains("卷") { "Vol. " } else { "Bk. " }
        itt.text.find(regex("\d+"))
      },
    )

    // 处理版本信息
    reptext = reptext.replace(
      regex("(第\s?)?\d+\s?[版本]"),
      itt => {
        let num = itt.text.find(regex("\d+"))
        num + (
          if num.clusters().len() == 2 and num.clusters().first() == "1" { "th" }
          else { ("1": "st", "2": "nd", "3": "rd").at(num.clusters().last(), default: "th") }
        ) + " ed"
      },
    )

    // 处理译者信息
    reptext = reptext.replace(regex("\].+?译"), itt => {
      let comma-in-itt = itt.text.replace(regex(",?\s?译"), "").matches(",")
      if (type(comma-in-itt) == array and 
          comma-in-itt.len() >= (if allow-comma-in-name {2} else {1})) {
        if extra-comma-before-et-al-trans {
          itt.text.replace(regex(",?\s?译"), ", tran")
        } else {
          itt.text.replace(regex(",?\s?译"), " tran")
        }
      } else {
        itt.text.replace(regex(",?\s?译"), ", trans")
      }
    })

    // 处理"等"的特殊情况
    reptext = reptext.replace(
      regex("等."),
      itt => {
        "et al." + (if not itt.text.last() in (".", ",", ";", ":", "[", "]", "/", "\\", "<", ">", "?", "(", ")", " ", "\"", "'") { " " }) + (if not itt.text.last() == "." { itt.text.last() })
      },
    )

    // 处理其他中文字符
    reptext = reptext.replace(
      regex("\p{sc=Hani}+"),
      itt => {
        mapping.at(itt.text, default: itt.text)
      },
    )
    reptext
  }

  // 递归处理内容的函数
  let process-content(content) = {
    if type(content) == str {
      process-text(content)
    } else if content.has("children") {
      content.with(children: content.children.map(process-content))
    } else if content.has("body") {
      content.with(body: process-content(content.body))
    } else {
      content
    }
  }

  // 设置文本语言为中文
  set text(lang: "zh")
  
  // 分页控制，确保参考文献从奇数页开始（在双面打印模式下）
  pagebreak(weak: true, to: if need2page { "odd" })
  
  // 生成原始参考文献
  let bib = bibliography(

    title: title,
    full: full,
    style: style,
    
  )

  // 处理并返回修改后的参考文献
  process-content(bib)

  // 分页控制，确保参考文献后的内容从奇数页开始（在双面打印模式下）
  pagebreak(weak: true, to: if need2page { "odd" })

}
