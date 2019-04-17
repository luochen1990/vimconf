" To Find More Unicode: https://en.wikipedia.org/wiki/Mathematical_operators_and_symbols_in_Unicode

if exists('s:loaded') || exists('g:no_vim_conceal') || &enc != 'utf-8' | finish | endif | let s:loaded = 1

fun SynConceal()
  " programming
  syn match Operator "\>\s*\zs===\ze\s*\<" conceal cchar=≡
  syn match Operator "\>\s*\zs\~==\ze\s*\<" conceal cchar=≅
  syn match Operator "\>\s*\zs<=\ze\s*\<" conceal cchar=≤
  syn match Operator "\>\s*\zs>=\ze\s*\<" conceal cchar=≥
  syn match Operator "\>\s*\zs[!/]=\ze\s*\<" conceal cchar=≠

  syn match Operator "\>\s*\zs==?\ze\s*\<" conceal cchar=≟
  syn match Operator "\>\s*\zs<?\ze\s*\<" conceal cchar=⩻
  syn match Operator "\>\s*\zs>?\ze\s*\<" conceal cchar=⩼

  syn match Operator "\a\zs0\>" conceal cchar=₀
  syn match Operator "\a\zs1\>" conceal cchar=₁
  syn match Operator "\a\zs2\>" conceal cchar=₂
  syn match Operator "\a\zs3\>" conceal cchar=₃
  syn match Operator "\a\zs4\>" conceal cchar=₄
  syn match Operator "\a\zs5\>" conceal cchar=₅

  " arith
  syn match Operator "\>\s\+\zs/\ze\s\+\<" conceal cchar=÷
  syn match Operator "\>\s*\zs//\ze\s*\<" conceal cchar=➗ "⨸
  "syn match Operator "\v(import\s+)@8<!(\a|\s)@1<=\*\ze(\a|\s)" conceal cchar=×
  syn match Operator "[ ]\?\(\^\|\*\*\)[ ]\?2\>" conceal cchar=²
  syn match Operator "[ ]\?\(\^\|\*\*\)[ ]\?3\>" conceal cchar=³
  syn match Operator "\<\%([Mm]ath\.\)\?sqrt\>" conceal cchar=√
  syn match Operator "\<\%([Mm]ath\.\)\?pi\>" conceal cchar=π

  " abstract math
  syn match Operator "\>\s*\zs<>\ze\s*\<" conceal cchar=◇

  " logic
  "syn match Operator "\<not\>" conceal cchar=¬
  "syn match Operator "\<and\>" conceal cchar=∧
  "syn match Operator "\<or\>" conceal cchar=∨
  syn match Operator "\>\s*\zs&&\ze\s*\<" conceal cchar=∧
  syn match Operator "\>\s*\zs||\ze\s*\<" conceal cchar=∨

  " functional
  syn match Operator "\<lambda\>" conceal cchar=λ
  syn match Operator "\<forall\>" conceal cchar=∀
  syn match Operator "\<exists\>" conceal cchar=∃
  syn match Operator "\<undefined\>" conceal cchar=⊥

  " haskell
  syn match Operator "`elem`" conceal cchar=∈
  syn match Operator "\<log\ze\s*\<" conceal cchar=㏒
  "syn match Operator "\<sum\ze\s*\<" conceal cchar=∑

  " proof
  "syn match Operator ":=" conceal cchar=⩴
  "syn match Operator "::=" conceal cchar=⩴

  hi! link Conceal Operator
  setlocal conceallevel=1
endfun

auto syntax * call SynConceal()
auto colorscheme * call SynConceal()

