(when (require 'undercover nil t)
  (undercover "ffc.el"))

(require 'ffc)

(describe "ffc-define function"
          :var (name docstring on-define on-load) ;; helper variables

          (before-each ;; nilify affected library variables
           (setq ffc-alist nil))
          
          (before-each ;; build correct arguments
           (setq name 'name-symbol)
           (setq docstring "Documentation string.")
           (setq on-define (lambda () (ignore)))
           (setq on-load (lambda () (ignore))))
           
          (it "defines new configuration when args is correct"
              (ffc-define name docstring on-define on-load)
              (expect (alist-get name ffc-alist) :to-be-truthy))

          (it "raises error when NAME isn't a symbol"
              (expect
               (ffc-define "not a symbol" docstring on-define on-load)
               :to-throw 'ffc-invalid-name-error))

          (it "raises error when DOCSTRING isn't a string"
              (expect
               (ffc-define name 'not-a-string on-define on-load)
               :to-throw 'ffc-invalid-docstring-error))

          (it "raises error when ON-DEFINE isn't a function"
              (expect
               (ffc-define name docstring "not a function" on-load)
               :to-throw 'ffc-invalid-on-define-error))

          (it "raises error when ON-LOAD isn't a function"
              (expect
               (ffc-define name docstring on-define "not a function")
               :to-throw 'ffc-invalid-on-load-error))

          (it "raises error when configuration with same NAME already loaded"
              (ffc-define name docstring on-define on-load)
              (expect
               (ffc-define name docstring on-define on-load)
               :to-throw 'ffc-already-defined-error))
          )
