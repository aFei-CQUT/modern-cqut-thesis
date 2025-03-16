// 一个简单的自定义 Numbering
// A simple custom Numbering
// 用法也简单，可以特殊设置一级等标题的样式，以及一个缺省值
// The usage is simple, and you can customize the style of each heading level, with a default value.

#let custom-numbering(
  base: 1,                // Starting from 1 for main content
  depth: 5,               // Depth of the numbering
  first-level: auto,      // First level, typically "Chapter 1", "I", etc.
  second-level: auto,     // Second level (e.g., "1.1")
  third-level: auto,      // Third level (e.g., "1.1.1")
  format,                 // Formatting style for the numbering
  ..args
) = {
  // Ensure we don't exceed the allowed depth
  if (args.pos().len() > depth) {
    return
  }

  // First-level numbering
  if (first-level != auto and args.pos().len() == 1) {
      if (first-level != "") {
          numbering(first-level, ..args)  // Apply first-level numbering (e.g., "I", "1", etc.)
      }
      return
  }

  // Second-level numbering
  if (second-level != auto and args.pos().len() == 2) {
      if (second-level != "") {
          numbering(second-level, ..args)  // Apply second-level numbering (e.g., "1.1", "I.1", etc.)
      }
      return
  }

  // Third-level numbering
  if (third-level != auto and args.pos().len() == 3) {
      if (third-level != "") {
          numbering(third-level, ..args)  // Apply third-level numbering (e.g., "1.1.1")
      }
      return
  }

  // Default numbering for higher levels or specific formats
  if (args.pos().len() >= base) {
      numbering(format, ..(args.pos().slice(base - 1)))  // Apply the custom format for numbering
      return
  }
}
