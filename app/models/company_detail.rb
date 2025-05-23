class CompanyDetail < ApplicationRecord
  COMPANY = {
    yut: 0,
    td: 1,
    yk_td: 2,
    yut_plus: 3,
    yk_centr: 4,
    yk_jkh: 5
  }.freeze

  enum company: COMPANY
end
