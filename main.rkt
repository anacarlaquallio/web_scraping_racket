#lang racket

(require net/url)
(require html)
 
  ; Some of the symbols in html and xml conflict with
  ; each other and with racket/base language, so we prefix
  ; to avoid namespace conflict
  (require (prefix-in h: html)
           (prefix-in x: xml))
 
; Extrai conteúdo HTML de uma página e converte em string 
(define an-html
    (h:read-xhtml
     (open-input-string
     (string-append (bytes->string/utf-8 (port->bytes (get-pure-port (string->url "https://docs.racket-lang.org/sxml-intro/index.html")))))
    ))
)
 
  ; Define uma função que recebe o conteúdo HTML e retorna lista de strings
  (define (extract-pcdata some-content)
    (cond [(x:pcdata? some-content)
           (list (x:pcdata-string some-content))]
          [(x:entity? some-content)
           (list)]
          [else
           (extract-pcdata-from-element some-content)]))
 
  ; Verificação do HTML e concatenação de todas as listas
  (define (extract-pcdata-from-element an-html-element)
    (match an-html-element
      [(struct h:html-full (attributes content))
       (apply append (map extract-pcdata content))]
 
      [(struct h:html-element (attributes))
       '()]))
 
  (printf "~s\n" (extract-pcdata an-html))
 


