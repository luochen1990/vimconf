" To Find More Unicode: https://en.wikipedia.org/wiki/Mathematical_operators_and_symbols_in_Unicode

if exists('s:loaded') || exists('g:no_vim_conceal') || &enc != 'utf-8' | finish | endif | let s:loaded = 1

fun SynConceal()
  " programming
  syn match concealOp "\>\s*\zs===\ze\s*\<" conceal cchar=≡
  syn match concealOp "\>\s*\zs\~==\ze\s*\<" conceal cchar=≅
  syn match concealOp "\>\s*\zs<=\ze\s*\<" conceal cchar=≤
  syn match concealOp "\>\s*\zs>=\ze\s*\<" conceal cchar=≥
  syn match concealOp "\>\s*\zs[!/]=\ze\s*\<" conceal cchar=≠

  syn match concealOp "\>\s*\zs==?\ze\s*\<" conceal cchar=≟
  syn match concealOp "\>\s*\zs<?\ze\s*\<" conceal cchar=⩻
  syn match concealOp "\>\s*\zs>?\ze\s*\<" conceal cchar=⩼

  syn match concealOp "\a\zs0\>" conceal cchar=₀
  syn match concealOp "\a\zs1\>" conceal cchar=₁
  syn match concealOp "\a\zs2\>" conceal cchar=₂
  syn match concealOp "\a\zs3\>" conceal cchar=₃
  syn match concealOp "\a\zs4\>" conceal cchar=₄
  syn match concealOp "\a\zs5\>" conceal cchar=₅

  " arith
  syn match concealOp "\>\s\+\zs/\ze\s\+\<" conceal cchar=÷
  syn match concealOp "\>\s*\zs//\ze\s*\<" conceal cchar=➗ "⨸
  "syn match concealOp "\v(import\s+)@8<!(\a|\s)@1<=\*\ze(\a|\s)" conceal cchar=×
  syn match concealOp "[ ]\?\(\^\|\*\*\)[ ]\?2\>" conceal cchar=²
  syn match concealOp "[ ]\?\(\^\|\*\*\)[ ]\?3\>" conceal cchar=³
  syn match concealOp "\<\%([Mm]ath\.\)\?sqrt\>" conceal cchar=√
  syn match concealOp "\<\%([Mm]ath\.\)\?pi\>" conceal cchar=π

  " abstract math
  syn match concealOp "\>\s*\zs<>\ze\s*\<" conceal cchar=◇

  " logic
  "syn match concealOp "\<not\>" conceal cchar=¬
  "syn match concealOp "\<and\>" conceal cchar=∧
  "syn match concealOp "\<or\>" conceal cchar=∨
  syn match concealOp "\>\s*\zs&&\ze\s*\<" conceal cchar=∧
  syn match concealOp "\>\s*\zs||\ze\s*\<" conceal cchar=∨

  " functional
  syn match concealOp "\<lambda\>" conceal cchar=λ
  syn match concealOp "\<forall\>" conceal cchar=∀
  syn match concealOp "\<exists\>" conceal cchar=∃
  syn match concealOp "\<undefined\>" conceal cchar=⊥

  " haskell
  syn match concealOp "`elem`" conceal cchar=∈
  syn match concealOp "\<log\ze\s*\<" conceal cchar=㏒
  syn match concealOp "\<sqrt\ze\s*\<" conceal cchar=√
  "syn match concealOp "\<sum\ze\s*\<" conceal cchar=∑
  syn match concealOpLam "\(\s\|^\)\zs\\\ze[ _0-9a-zA-Z'\[\](,)]\+->" conceal cchar=λ "nextgroup=concealOpLamSep
  "syn match concealOpLamSep "[ _0-9a-zA-Z'\[\](,)]*\zs->" conceal cchar=. contained

  " proof
  "syn match concealOp ":=" conceal cchar=⩴
  "syn match concealOp "::=" conceal cchar=⩴

  hi! link concealOp Operator
  hi! link concealOpLam Operator
  hi! link concealOpLamSep Operator
  hi! link Conceal Operator
  setlocal conceallevel=1
endfun

auto syntax * call SynConceal()
auto colorscheme * call SynConceal()

