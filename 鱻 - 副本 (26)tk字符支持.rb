require 'Win32API'
# require 'dl/win32'

class Win32API
  # type flag
  MB_OK               = 0
  MB_OKCANCEL         = 1
  MB_ABORTRETRYIGNORE = 2
  MB_YESNOCANCEL      = 3
  MB_YESNO            = 4
  MB_RETRYCANCEL      = 5

  # return values
  IDOK     = 1
  IDCANCEL = 2
  IDABORT  = 3
  IDRETRY  = 4
  IDIGNORE = 5
  IDYES    = 6
  IDNO     = 7

  def Win32API.MessageBox(wnd, text, caption, type = MB_OK)
    messagebox = Win32API.new('user32', 'MessageBox', %w(p p p i), 'i')

    messagebox.call(wnd, text, caption, type)
  end

  def Win32API.MessageBoxEx(wnd, text, caption, type = MB_OK, languageid = 0)
    messagebox = Win32API.new('user32', 'MessageBoxEx', %w(p p p i i), 'i')

    messagebox.call(wnd, text, caption, type, languageid)
  end
end

p Win32API.MessageBox(0, "test message", "test caption")
p Win32API.MessageBoxEx(0, "test message", "test caption")
p Win32API.MessageBox(0, "てすと", "テスト")
p Win32API.MessageBoxEx(0, "てすと", "テスト")