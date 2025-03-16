// 导出 anti-matter 中的函数
// Export functions from anti-matter

#let (
  anti-front-end,
  anti-inner-end,
  anti-outer-counter,
  anti-inner-counter,
  anti-active-counter-at,
  anti-page-at,
  anti-page,
  anti-header,
  anti-thesis,
  anti-matter,
) = {

  // 验证spec
  // Validate spec
  let assert-spec-valid(spec) = {
    if type(spec) != dictionary {
      panic("spec必须是一个字典,而不是 " + type(spec))  // "spec must be a dictionary, not " + type(spec)
    }

    if spec.len() != 3 {
      panic("spec必须恰好有3个元素,而不是 " + str(spec.len()))  // "spec must have exactly 3 elements, not " + str(spec.len())
    }

    if "front" not in spec { panic("缺少front键") }  // "Missing 'front' key"
    if "inner" not in spec { panic("缺少inner键") }  // "Missing 'inner' key"
    if "back" not in spec { panic("缺少back键") }  // "Missing 'back' key"
  }

  let meta-label = <anti-matter:label>
  let key-front-end = "anti-matter:front-end"
  let key-inner-end = "anti-matter:inner-end"

  // 获取给定位置的事项和修正
  // Get the relevant section and correction for the page numbering
  let where-am-i(spec, loc) = {
    let markers = query(meta-label)

    assert.eq(
      markers.len(),
      2,
      message: "必须恰好有两个标记(不要使用 <anti-matter:meta>)"  // "There must be exactly two markers (do not use <anti-matter:meta>)"
    )
    assert.eq(markers.at(0).value, key-front-end, message: "第一个标记必须是前端标记")  // "The first marker must be the front-end marker"
    assert.eq(markers.at(1).value, key-inner-end, message: "第二个标记必须是内部结束标记")  // "The second marker must be the inner-end marker"

    let front-matter = markers.first().location()
    let inner-matter = markers.last().location()

    let front-matter-end = counter(page).at(front-matter).at(0)
    let inner-matter-end = counter(page).at(inner-matter).at(0)

    if loc.page() <= front-matter.page() {
      ("front", spec.front, 0)
    } else if front-matter.page() < loc.page() and loc.page() <= inner-matter.page() {
      ("inner", spec.inner, front-matter-end)
    } else {
      ("back", spec.back, inner-matter-end - front-matter-end)
    }
  }

  // 标记文档前端事项的结束,将其放在前端事项的最后一页。
  // Mark the end of the front matter, placing it on the last page of the front section.
  let anti-front-end() = [#metadata(key-front-end) #meta-label]

  // 标记文档内部事项的结束,将其放在内部事项的最后一页。
  // Mark the end of the main content, placing it on the last page of the content section.
  let anti-inner-end() = [#metadata(key-inner-end) #meta-label]

  // 返回文档前端和后端事项的计数器。
  // Return the counter for the front and back sections of the document.
  let anti-outer-counter() = counter("anti-matter:outer")

  // 返回文档主要内容的计数器。
  // Return the counter for the main content section.
  let anti-inner-counter() = counter("anti-matter:inner")

  // 返回给定位置的活动计数器。这可用于在特定位置设置页面计数器。
  // Return the active counter for a given location. This is useful for setting the page counter at a specific position.
  // - spec (dictionary): The document specification, see @@anti-matter
  // - loc (location): The location for the counter
  let anti-active-counter-at(spec, loc) = {
    let (matter, _, _) = where-am-i(spec, loc)

    if matter == "inner" {
      anti-inner-counter()  // Return inner content counter
    } else {
      anti-outer-counter()  // Return outer content counter
    }
  }

  // 使用默认规格,共享外部编号和计数器。
  // Use the default specification to share the outer numbering and counter.
  // 返回的字典包含`front`、`inner`和`back`键的编号。
  // The returned dictionary contains numbering for `front`, `inner`, and `back`.
  let anti-thesis(outer: "I", inner: "1") = (
    front: outer,  // Front matter uses Roman numerals (I, II, III)
    inner: inner,  // Main content uses Arabic numerals (1, 2, 3)
    back: outer,   // Back matter uses Roman numerals (I, II, III)
  )

  // 返回给定位置的页面编号,根据规格进行必要的调整和编号。
  // Return the page number for a given location, adjusting according to the specification.
  // - spec (dictionary): Document specification
  // - loc (location): Location to calculate the page number
  let anti-page-at(spec, loc) = {
    let (_, num, correction) = where-am-i(spec, loc)

    let vals = counter(page).at(loc)
    vals.at(0) = vals.at(0) - correction

    numbering(num, ..vals)
  }

  // 返回给定位置的格式化页码,根据规格进行必要的调整和编号。
  // Return the formatted page number for a given location, adjusting according to the specification.
  // - spec (dictionary): Document specification
  let anti-page(spec) = context {
    let loc = here()
    anti-page-at(spec, loc)
  }

  // 渲染页眉,同时维护anti-matter计数器步进。
  // Render the header while maintaining the anti-matter counter.
  // - spec (dictionary): Document specification
  // - header (content): The header content to be rendered
  let anti-header(spec, header) = {
    context {
      let loc = here()
      anti-active-counter-at(spec, loc).step()  // Step the active counter for the header
    }
    header
  }

  // 应用页面编号和outline.entry的show规则以修复其页面编号的模板函数。
  // Apply page numbering and outline entry show rules to fix page numbering.
  // - spec (dictionary): Document specification
  // - debug (bool): Show current section and related info in the header
  // - body (content): Content to render with anti-matter numbering
  let anti-matter(
    spec: anti-thesis(),
    debug: false,
    body,
  ) = {
    assert-spec-valid(spec)

    set page(
      header: if debug {
        context {
          let loc = here()
          anti-header(spec)[
            #let (matter, numbering, correction) = where-am-i(spec, loc)
            #(matter: matter, numbering: numbering, correction: correction)
          ]
        }
      } else {
        anti-header(spec, none)
      },
      numbering: (..args) => anti-page(spec),
    )
    show outline.entry: it => {
      link(it.element.location(), it.body)
      if it.fill != none {
        [ ]
        box(width: 1fr, it.fill)
        [ ]
      } else {
        h(1fr)
      }
      link(it.element.location(), anti-page-at(spec, it.element.location()))
    }

    body
  }

  (
    anti-front-end,
    anti-inner-end,
    anti-outer-counter,
    anti-inner-counter,
    anti-active-counter-at,
    anti-page-at,
    anti-page,
    anti-header,
    anti-thesis,
    anti-matter,
  )
}
