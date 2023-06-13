#lang racket
; Carrega bibliotecas
(require net/url)
(require sxml/sxpath)
(require html-parsing)
(require racket/string)

; Renomeia as bibliotecas para evitar conflitos de nome entre as funções e símbolos 
(require (prefix-in h: html)
         (prefix-in x: xml))

; Obtem parágrafos diante da palavra chave de forma recursiva
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

; Extração do título da página
(define (get-title lst)
  (cond
    ((null? lst) "")  ; Caso base: lista vazia
    (else
     (string-append (car lst) (get-title (cdr lst))))))

; Obtenção SXML da URL
(define (scrape-website keyword xpath base-url)
  (define my-html
    (html->xexp
     (get-pure-port
      (string->url base-url))))

; Funções de extração de parágrafos e título, conforme XPath especificado em teste.rkt
(define paragraphs-string (get-paragraphs-as-string ((sxpath xpath) my-html) keyword))
(define title-string (get-title ((sxpath "/html/head/title/text()") my-html)))

; Geração do arquivo HTML de saída
(define output-html
    (string-append
     "<html>\n"
     "  <head>\n<title>Resultado do Web Scraping</title>\n</head>\n"
     "  <body>\n"
     "    <h3>🌺 Título da Página: </h3>"
     "    <div>" title-string "</div>\n"
     "    <h3>Lista de flores com a palavra-chave " keyword ":</h3>\n"
     "    <ul>\n" paragraphs-string "    </ul>\n"
     "  </body>\n"
     "</html>\n"
    )
)
  output-html
)

; Para a importação em outros arquivos
(provide scrape-website)