# encoding: UTF-8

class String

  def to_safe_string

    self
      .tr(
'ÀÁÂÃÄÅÈÉÊËĒĔĖĘĚÒÓÔÕÖØÙÚÛÜŨŪŬŮŰÌÍÎÏìíîïĨĩĪīĬĭéèêëēĕėęěúùûüũūŭůűùçàâêôáāēōäëö',
'AAAAAAEEEEEEEEEOOOOOOUUUUUUUUUIIIIiiiiIiIiIieeeeeeeeeuuuuuuuuuucaaeoaaeoaeo')
      .gsub(/[^a-zA-Z0-9]/, '_')
  end
end

