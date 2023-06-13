#lang racket
; Carrega bibliotecas
(require net/url)
(require sxml/sxpath)
(require html-parsing)
(require racket/string)

; Renomeia as bibliotecas para evitar conflitos de nome entre as funções e símbolos 
(require (prefix-in h: html)
         (prefix-in x: xml))

(define (get-paragraphs-as-string lst keyword)
  (cond
    ((null? lst) "")  ; Caso base: lista vazia
    (else
     (if (not (null? keyword))
         (let* ((line (car lst))
                (lower-case-line (string-downcase line))
                (lower-case-keyword (string-downcase keyword)))
           (if (string-contains? lower-case-line lower-case-keyword)
               (string-append "      <li>" line "</li>\n" (get-paragraphs-as-string (cdr lst) keyword))
               (get-paragraphs-as-string (cdr lst) keyword)))
         (string-append "      <li>" (car lst) "</li>\n" (get-paragraphs-as-string (cdr lst) keyword))))))

(define (get-title lst)
  (cond
    ((null? lst) "")  ; Caso base: lista vazia
    (else
     (string-append (car lst) (get-title (cdr lst))))))

(define (scrape-website keyword xpath base-url)
  (define my-html
    (html->xexp
     (get-pure-port
      (string->url base-url))))

  (define paragraphs-string (get-paragraphs-as-string ((sxpath xpath) my-html) keyword))
  (define title-string (get-title ((sxpath "/html/head/title/text()") my-html)))

  (define output-html
    (string-append
     "<html>\n"
     "  <head>\n<title>Resultado do Web Scraping</title>\n</head>\n"
     "  <div align='center'>\n<h2>🖤 Verifique o web scraping criado 🖤</h2>\n</div>\n"
     "  <body>\n"
     "    <h3>Título da Página:</h3>\n"
     "    <div>" title-string "</div>\n"
     "    <h3>Lista de flores com a palavra chave " keyword ":</h3>\n"
     "    <ul>\n" paragraphs-string "    </ul>\n"
     "  </body>\n"
     "</html>\n"
    )
  )

  output-html
)

(provide scrape-website)
