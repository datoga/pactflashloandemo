;; ================================================
;;               module-and-keyset
;; ================================================

(define-keyset 'flashloans-admin-keyset (read-keyset "flashloans-admin-keyset"))
(module flashloans 'flashloans-admin-keyset

;; ================================================
;;              schemas and tables
;; ================================================

  (defschema reserve
    asset:string
    balance:decimal
    )

  (defschema flash-loan-history
    receiver:string
    asset:string
    amount:decimal
    premiumFeePayed:decimal
    )

  (deftable reserve-table:{reserve})

  (deftable flash-loans-history-table:{flash-loan-history})

  ;; ================================================
  ;;              consts
  ;; ================================================

  (defconst FLASHLOAN_PREMIUM_TOTAL 0.09)
  (defconst FLASHLOAN_PREMIUM_TO_PROTOCOL 0.00)

  ;; ================================================
  ;;               functions
  ;; ================================================

  (defun set-treasury (asset amount)
  (insert reserve-table asset {
    "asset":asset,
    "balance":amount
    })

    (format "Added {} to {} treasury" [amount asset])
 )

   (defun flash-loan-simple (loanId receiver asset amount)
    (let*  (
            (fee (+ FLASHLOAN_PREMIUM_TOTAL FLASHLOAN_PREMIUM_TO_PROTOCOL))
            (premiumFeePayed (* amount fee))
          )
          (format "Assets {} {}, premiumFeePayed {}" [amount asset premiumFeePayed])
          (with-read reserve-table asset {
            "balance":= balance
            }
            (format "Available {}" [balance])

           (update reserve-table asset {
              "balance": (+ balance premiumFeePayed)
            })

            (insert flash-loans-history-table loanId {
               "receiver": receiver,
               "asset": asset,
               "amount": amount,
               "premiumFeePayed": premiumFeePayed
             })
          )
      )
  )


  (defun read-history-flash-loans ()
    (select flash-loans-history-table (constantly true)))

  (defun read-reserve ()
      (select reserve-table (constantly true)))
)

;; ================================================
;;                 create-tables
;; ================================================

(create-table reserve-table)
(create-table flash-loans-history-table)
