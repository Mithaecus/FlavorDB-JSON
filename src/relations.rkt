#lang racket

(require json racklog)

; Global State
(define *DATA* (make-hash))
(define %category %empty-rel)

; Load json into *DATA*
(define (load-data list-of-files)
    (if (null? list-of-files)
        (void)
        (begin
            (let ()
                (define file-name (car list-of-files))
                (define file-data (call-with-input-file file-name read-json))
                (hash-set! *DATA* (string->symbol (hash-ref file-data 'entity_alias)) file-data)
                (load-data (cdr list-of-files))))))

; Build relations between entity_alias and category in %category
(define (create-entity-category-relations data)
    (if (null? data)
        (void)
        (begin
          (let ()
            (define a (string->symbol (hash-ref (hash-ref *DATA* (car data)) 'entity_alias)))
            (define b (string->symbol (hash-ref (hash-ref *DATA* (car data)) 'category)))
            (%assert! %category () ([a b]))
            (create-entity-category-relations (cdr data))))))

; Do the work
(load-data (map path->string (directory-list "./data/flavordb/" #:build? #t)))
(create-entity-category-relations (hash-keys *DATA*))

(%which ()
    (%category 'bread 'bakery))
