// 日本語フォント設定
#let font-mincho = ("Hiragino Mincho Pro", "Noto Serif", "Noto Serif CJK JP", "MS Mincho", "Yu Mincho", "Hiragino Mincho ProN")
#let font-gothic = ("Hiragino Sans", "Noto Sans", "Noto Sans CJK JP", "MS Gothic", "Yu Gothic", "Hiragino Kaku Gothic ProN")
#let font-code = ("Consolas", "Roboto Mono", "Menlo", "Courier New")

// テンプレート本体
#let project(
  title: "",
  author: "",
  student-id: "",
  mentor: "",
  date: datetime.today().display("[year]年[month]月[day]日"),
  body,
) = {
  set document(title: title, author: author)

  set text(
    font: font-mincho,
    size: 11.3pt, // 40文字 x 45列
    lang: "ja",
  )

  set page(
    paper: "a4",
    margin: (inside: 30mm, outside: 20mm, top: 30mm, bottom: 30mm),
    numbering: "1",
  )

  set par(
    first-line-indent: 1em,
    leading: 0.57em,
    justify: true,
  )

  set math.equation(numbering: "(1.1)")

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    counter(math.equation).update(0)
    counter(figure).update(0)
    set text(font: font-gothic, weight: "bold", size: 16pt)
    set block(spacing: 1.5em)
    if it.numbering != none {
      text(size: 14pt)[第 #counter(heading).display() 章]
      parbreak()
    }
    text(size: 20pt)[#it.body]
    v(1em)
  }
  show heading.where(level: 2): it => {
    set text(font: font-gothic, weight: "bold", size: 14pt)
    block(above: 1.5em, below: 1em, it)
  }
  show heading.where(level: 3): it => {
    set text(font: font-gothic, weight: "bold", size: 12pt)
    block(above: 1.2em, below: 0.8em, it)
  }
  set heading(numbering: "1.1")

  // 図表・数式の番号リセットロジック
  set figure(numbering: (..nums) => context {
    let chap = counter(heading).get().first()
    str(chap) + "." + nums.pos().map(str).join(".")
  })
  set math.equation(numbering: num => context {
    let chap = counter(heading).at(here()).first()
    "(" + str(chap) + "." + str(num) + ")"
  })

  // 数式は前後空白
  show math.equation.where(block: true): it => {
    v(1em)
    it
    v(1em)
  }

  // コードブロック設定
  show raw.where(block: true): block.with(
    width: 100%,
    fill: luma(250),
    inset: (x: 2em, y: 1em),
    radius: 2pt,
  )
  show raw: set text(font: font-code, size: 10pt)

  // タイトルページ
  if (title != "") {
    // タイトルページのみページ番号なし
    set page(numbering: none)

    // 全体を中央揃え
    align(center)[
      #v(4cm)

      #text(size: 18pt)[#title]

      #v(13.25cm)

      #text(size: 14pt)[
        #grid(
          columns: 3,
          column-gutter: 0.5em,
          row-gutter: 0.8em,
          align: start,

          [学籍番号], [：], [#student-id],
          [氏　　名], [：], [#author],
          [指導教員], [：], [#mentor],
          [修了年月], [：], [#date],
        )
      ]
    ]
    pagebreak()
  }

  // 目次
  set page(numbering: "i")
  counter(page).update(1)

  align(center)[
    #text(size: 18pt, weight: "bold", font: font-gothic)[目 次]
    #v(1em)
  ]
  set par(
    first-line-indent: 1em,
    leading: 1em,
    justify: true,
  )
  outline(title: none, indent: auto)
  pagebreak()

  // 本文
  set par(
    first-line-indent: 1em,
    leading: 0.57em,
    spacing: 0.8em,
    justify: true,
  )
  set page(numbering: "-1-")
  counter(page).update(1)

  body

  show bibliography: it => {
    set heading(numbering: "1.1")
    it
  }
}

#let centered-x = table.cell.with(align: center + horizon)
