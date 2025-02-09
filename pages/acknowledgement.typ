// 致谢页
#let acknowledgement(
  // documentclass 传入参数
  anonymous: false,

  // 其他参数
  need2page:true,
  title: "致谢",
  outlined: true,
  body,
) = {
  if (not anonymous) {
    // 确保在双面打印时，从奇数页开始
    pagebreak(weak: true, to: if need2page { "odd" })
    [
      #heading(level: 1, numbering: none, outlined: outlined, title) <no-auto-pagebreak>

      #body
    ]
    // 确保在双面打印时，从偶数页结束
    pagebreak(weak: true, to: if need2page { "even" })
  }
}
