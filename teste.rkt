#lang racket
(require "scraping.rkt")

; Palavra-chave
(define keyword "rose")

; Definição URL e XPath
(define urls-xpaths
  `(("https://www.bioexplorer.net/plants/flowers/" . "//h3//text()")
    ("https://www.allaboutgardening.com/types-of-flowers/" . "//h2/strong/text()")))

; Definição do arquivo de saída
(define output-file "resultado.html")

; Processamento par URL e XPath
(define (scrape-and-append output-port url xpath)
  (let ((output-html (scrape-website keyword xpath url)))
    (display output-html output-port)))

(define (scrape-multiple-websites urls-xpaths output-file)
  (call-with-output-file output-file
    (lambda (output-port)
      (scrape-and-append-all output-port urls-xpaths))))

(define (scrape-and-append-all output-port urls-xpaths)
  (if (null? urls-xpaths)
      'done ; Base case: quando a lista está vazia, terminamos
      (begin
        (let ((url-xpath (car urls-xpaths)))
          (let ((url (car url-xpath))
                (xpath (cdr url-xpath)))
            (scrape-and-append output-port url xpath)))
        (scrape-and-append-all output-port (cdr urls-xpaths)))))

; Geração arquivo de saída
(if (file-exists? output-file)
    (printf "O arquivo de saída já existe\n")
    (begin
      (scrape-multiple-websites urls-xpaths output-file)
      (printf "O resultado foi salvo no arquivo ~a\n" output-file)
    )
)
