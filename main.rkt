#lang racket
; Carrega bibliotecas
(require net/url)
(require sxml/sxpath)
(require html-parsing)
(require racket/string)

; Renomeia as bibliotecas para evitar conflitos de nome entre as funções e símbolos 
(require (prefix-in h: html)
         (prefix-in x: xml))

; Palavra-chave para web scraping
(define keyword "html")

; URL base
(define base-url "https://docs.racket-lang.org/search/index.html?q=")

; Concatenação da palavra chave com URL
(define (replace-whitespace-with-hyphen keyword)
  (string-replace keyword " " "-"))
(define modified-keyword
  (if (string-contains? keyword " ")
      (replace-whitespace-with-hyphen keyword)
      keyword))

; Função com URL válida
(define url-with-keyword (string-append base-url modified-keyword))

; Extração de HTML em uma expressão XML
(define my-html
  (html->xexp
   (get-pure-port
    (string->url url-with-keyword))))

; Função auxiliar recursiva para obter os parágrafos
(define (get-paragraphs-as-string lst)
  (cond
    ((null? lst) "")  ; Caso base: lista vazia
    (else
     (string-append (car lst) "\n" (get-paragraphs-as-string (cdr lst))))))

; Obter os parágrafos como uma string
(define paragraphs-string (get-paragraphs-as-string ((sxpath "//p/text()") my-html)))
; Obter titulo como string
(define title-string (get-paragraphs-as-string ((sxpath "/html/head/title/text()") my-html)))

; Função que gera HTML das listas filtradas
(define output-html
  (string-append
   "<html>"
   "<head><title>Resultado do Web Scraping</title></head>"
   "<div align='center'><h2>🖤 Verifique o web scraping criado 🖤</h2></div>"
   "<body>"
   "<h3>Título da Página:</h3>"
   "<div>" title-string "</div>"
   "<h3>Parágrafos:</h3>"
   "<div>" paragraphs-string "</div>"
   "</body>"
   "</html>"
  )
)

; Nome do arquivo de saída
(define output-file "output.html")

; Verifica se o arquivo de saída já existe
(if (file-exists? output-file)
    (printf "O arquivo de saída já existe\n")
    (begin
      ; Escreve o conteúdo HTML no arquivo de saída
      (call-with-output-file output-file
        (lambda (out-port)
          (display output-html out-port))
      )
      (printf "O resultado foi salvo no arquivo ~a\n" output-file)
    )
)