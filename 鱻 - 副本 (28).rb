require 'Win32API'

class EnumDisplaySetting
  DM_188_FLAG_S_LEN = 188
  DM_188_FLAG_W_LEN = 220

  DM_188_Pointer_FLAG     = "A32S4Ls13A32SL*"
  DM_188_Display_FLAG     = "A32S4L5s5A32SL*"


  # 188 type flag
  DM_DeviceName        = 0
  DM_SpecVersion       = 1
  DM_DriverVersion     = 2
  DM_Size              = 3
  DM_DriverExtra       = 4
  DM_Fields            = 5

  # Printer
  DM_Orientation       = 6
  DM_PaperSize         = 7
  DM_PaperLength       = 8
  DM_PaperWidth        = 9
  DM_Scale             = 10
  DM_Copies            = 11
  DM_DefaultSource     = 12
  DM_PrintQuality      = 13
  DM_Color_p             = 14
  DM_Duplex_p            = 15
  DM_YResolution_p       = 16
  DM_TTOption_p          = 17
  DM_Collate_p           = 18
  DM_FormName_p          = 19
  DM_LogPixels_p         = 20
  DM_BitsPerPel_p        = 21
  DM_PelsWidth_p         = 22
  DM_PelsHeight_p        = 23
  DM_DisplayFlags_p      = 24
  DM_DisplayFrequency_p  = 25

  # Display
  DM_Position_x         = 6  # 显示器的坐标原点X
  DM_Position_y         = 7  # 显示器的坐标原点Y
  DM_DisplayOrientation = 8  # 显示方向：0 - DMDO_DEFAULT; 1 - DMDO_90; 2 - DMDO_180; 3 - DMDO_270; 
  DM_DisplayFixedOutput = 9  # 固定分辨率屏幕显示小分辨率图像时的方式： 0 - DMDFO_DEFAULT; 1 - DMDFO_STRETCH; 2 - DMDFO_CENTER;
  DM_Color_d             = 10  # 彩色打印机的色彩模式：1 - DMCOLOR_MONOCHROME(单色); 2 - DMCOLOR_COLOR(彩色)
  DM_Duplex_d            = 11  # 双面打印，还是单面
  DM_YResolution_d       = 12
  DM_TTOption_d          = 13
  DM_Collate_d           = 14
  DM_FormName_d          = 15
  DM_LogPixels_d         = 16
  DM_BitsPerPel_d        = 17
  DM_PelsWidth_d         = 18
  DM_PelsHeight_d        = 19
  DM_DisplayFlags_d      = 20
  DM_DisplayFrequency_d  = 21




  def initialize(value)
    @info = value.unpack(DM_188_Display_FLAG)
    @model = "Display"
  end

  def Width
    @info[DM_PelsWidth_d]
  end

  def Height
    @info[DM_PelsHeight_d]
  end

  def Value
    @info
  end
end


def get_display_settings
  d_output = ["default", "stretch", "center"]
  eumn = Win32API.new("user32", "EnumDisplaySettings", ['P', 'L', 'P'], 'I')
  info ="\0"*EnumDisplaySetting::220
  i=0
  while eumn.call(nil, i, info) == 1 do
      setting = EnumDisplaySetting.new info
      str = ""
      str << "[" << i.to_s << "]"
      str << "width: " <<  setting.Width.to_s << "; "
      str << "height: " << setting.Height.to_s << "; " 
      str << "frequency: " << setting.Value[21].to_s << " Hz; "
      oidx = setting.Value[9]
      str << "fixed output: " << oidx.to_s << "(" << d_output[oidx] << "); "
    puts str
    i = i+1;    
  end
end

get_display_settings
system"pause"