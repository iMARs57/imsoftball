class MembersController < ApplicationController
  
  require 'time'
  require 'date'
  require 'active_support/core_ext/integer/inflections'
  
  def dateEN2CH(date)
	if date != nil && date.year >= 1912
		
		chinese_number = ["零","一","二","三","四","五","六","七","八","九"]
		# for 'year'
		year_minguo = date.year - 1911
		year_minguo_digit_3 = (year_minguo / 10**2) % 10
		year_minguo_digit_2 = (year_minguo / 10**1) % 10
		year_minguo_digit_1 = (year_minguo / 10**0) % 10
		yearCH = "民國"
		if(year_minguo_digit_3 != 0)
			yearCH += chinese_number[year_minguo_digit_3]
			yearCH += "百"
		end
		if(year_minguo_digit_2 == 0)
			if(year_minguo_digit_3 != 0)
				yearCH += chinese_number[year_minguo_digit_2]
			end
		else
			yearCH += chinese_number[year_minguo_digit_2]
			yearCH += "十"
		end
		if(year_minguo_digit_1 != 0)
			yearCH += chinese_number[year_minguo_digit_1]
		end
		yearCH += "年"
		
		# for 'month'
		month_digit_2 = (date.month / 10**1) % 10
		month_digit_1 = (date.month / 10**0) % 10
		monthCH = ""
		if(month_digit_2 != 0)
			monthCH += "十"
		end
		if(month_digit_1 != 0)
			monthCH += chinese_number[month_digit_1]
		end
		monthCH += "月"
		
		# for 'day'
		day_digit_2 = (date.day / 10**1) % 10
		day_digit_1 = (date.day / 10**0) % 10
		dayCH = ""
		if(day_digit_2 == 1)
			dayCH += "十"
		elsif(day_digit_2 == 2)
			dayCH += "廿"
		elsif(day_digit_2 == 3)
			dayCH += "卅"
		end
		if(day_digit_1 != 0)
			dayCH += chinese_number[day_digit_1]
		end
		dayCH += "日"
		
		return yearCH + monthCH + dayCH
	end
  end
  
  def date2Horoscope(date)
	if date != nil
		dateNumber = 100 * date.month + date.day
		@Horoscope = Array.new(2)
		if dateNumber >= 120 && dateNumber <= 218
			@Horoscope[0] = "Aquarius"
			@Horoscope[1] = "水瓶座"
		elsif dateNumber >= 219 && dateNumber <= 320
			@Horoscope[0] = "Pisces"
			@Horoscope[1] = "雙魚座"
		elsif dateNumber >= 321 && dateNumber <= 419
			@Horoscope[0] = "Aries"
			@Horoscope[1] = "牡羊座"
		elsif dateNumber >= 420 && dateNumber <= 520
			@Horoscope[0] = "Taurus"
			@Horoscope[1] = "金牛座"
		elsif dateNumber >= 521 && dateNumber <= 621
			@Horoscope[0] = "Gemini"
			@Horoscope[1] = "雙子座"
		elsif dateNumber >= 622 && dateNumber <= 722
			@Horoscope[0] = "Cancer"
			@Horoscope[1] = "巨蟹座"
		elsif dateNumber >= 723 && dateNumber <= 822
			@Horoscope[0] = "Leo"
			@Horoscope[1] = "獅子座"
		elsif dateNumber >= 823 && dateNumber <= 922
			@Horoscope[0] = "Virgo"
			@Horoscope[1] = "處女座"
		elsif dateNumber >= 923 && dateNumber <= 1023
			@Horoscope[0] = "Libra"
			@Horoscope[1] = "天秤座"
		elsif dateNumber >= 1024 && dateNumber <= 1122
			@Horoscope[0] = "Scorpio"
			@Horoscope[1] = "天蠍座"
		elsif dateNumber >= 1123 && dateNumber <= 1221
			@Horoscope[0] = "Sagittarius"
			@Horoscope[1] = "射手座"
		else
			@Horoscope[0] = "Capricorn"
			@Horoscope[1] = "魔羯座"
		end
		
		return @Horoscope
	
	end
  end
  
  def checkforCG(gameID, teamID)
	return Pitching.where('pitchings.game_id = "' + gameID + '" AND pitchings.team_id = "' + teamID + '"').count('pitchings.game_id')
  end
  helper_method :checkforCG
  
  def pitchingFromYear(year)
  
	if year < 2011
		annualYear = '0' + (year - 1911).to_s
	else
		annualYear = (year - 1911).to_s
	end
	@annualPitching = Pitching.select('pitchings.*, games.time')
							  .where('pitchings.game_id LIKE "' + annualYear + '__"
								  AND pitchings.player_id = "' + @member.id + '"')
							  .joins('INNER JOIN games ON pitchings.game_id = games.game_id')
							  .order('game_id')
	
	@annualPitchingStatistic = Hash.new(0);
	@annualPitchingStatistic["Time"] = year.to_s + ".09~" + (year + 1).to_s + ".08"
	@annualPitchingStatistic["G"] = @annualPitching.size
	@annualPitching.each do |annualPit|
		if annualPit.order == 1
			@annualPitchingStatistic["GS"] += 1
		end
		if checkforCG(annualPit.game_id,annualPit.team_id) == 1
			@annualPitchingStatistic["CG"] += 1
		end
		if annualPit.W == 1
			@annualPitchingStatistic["W"] += 1
		end
		if annualPit.L == 1
			@annualPitchingStatistic["L"] += 1
		end
		if annualPit.SV == 1
			@annualPitchingStatistic["SV"] += 1
		end
		@annualPitchingStatistic["IP"] += annualPit.IPouts
		@annualPitchingStatistic["H"] += annualPit.H
		@annualPitchingStatistic["SO"] += annualPit.SO
		@annualPitchingStatistic["BB"] += annualPit.BB
		@annualPitchingStatistic["R"] += annualPit.R
		@annualPitchingStatistic["ER"] += annualPit.ER
	end
	
	@annualPitchingStatistic["ERA5"] = 15.0 * @annualPitchingStatistic["ER"] / @annualPitchingStatistic["IP"]
	@annualPitchingStatistic["ERA7"] = 21.0 * @annualPitchingStatistic["ER"] / @annualPitchingStatistic["IP"]
	
	return @annualPitchingStatistic 
  end
  helper_method :pitchingFromYear
  
  def battingFromYear(year)
  
	if year < 2011
		annualYear = '0' + (year - 1911).to_s
	else
		annualYear = (year - 1911).to_s
	end
	@annualBatting = Batting.select('battings.*, games.time')
							  .where('battings.game_id LIKE "' + annualYear + '__"
								  AND battings.player_id = "' + @member.id + '"')
							  .joins('INNER JOIN games ON battings.game_id = games.game_id')
							  .order('game_id')
							  
	@annualBattingStatistic = Hash.new(0);
	@annualBattingStatistic["Time"] = year.to_s + ".09~" + (year + 1).to_s + ".08"
	@annualBattingStatistic["G"] = @annualBatting.size
	@annualBatting.each do |annualBat|
		@annualBattingStatistic["PA"] += (annualBat.AB + annualBat.BB + annualBat.IBB + annualBat.SF)
		@annualBattingStatistic["AB"] += annualBat.AB
		@annualBattingStatistic["H"] += annualBat.H
		@annualBattingStatistic["B2"] += annualBat.B2
		@annualBattingStatistic["B3"] += annualBat.B3
		@annualBattingStatistic["HR"] += annualBat.HR
		@annualBattingStatistic["R"] += annualBat.R
		@annualBattingStatistic["RBI"] += annualBat.RBI
		@annualBattingStatistic["SF"] += annualBat.SF
		@annualBattingStatistic["TB"] += (annualBat.HR * 4 + annualBat.B3 * 3 + annualBat.B2 * 2 + (annualBat.H - annualBat.B2 - annualBat.B3 - annualBat.HR))
		@annualBattingStatistic["SO"] += annualBat.SO
		@annualBattingStatistic["BB"] += annualBat.BB
	end
	
	@annualBattingStatistic["AVG"] = @annualBattingStatistic["H"] / @annualBattingStatistic["AB"].to_f
	@annualBattingStatistic["OBP"] = (@annualBattingStatistic["H"] + @annualBattingStatistic["BB"]) / @annualBattingStatistic["PA"].to_f
	@annualBattingStatistic["SLG"] = @annualBattingStatistic["TB"] / @annualBattingStatistic["AB"].to_f
	@annualBattingStatistic["OPS"] = ((@annualBattingStatistic["H"] + @annualBattingStatistic["BB"]) / @annualBattingStatistic["PA"].to_f) + (@annualBattingStatistic["TB"] / @annualBattingStatistic["AB"].to_f)
	
	return @annualBattingStatistic 
  end
  helper_method :battingFromYear
  
  def fieldingFromYear(year)
  
	if year < 2011
		annualYear = '0' + (year - 1911).to_s
	else
		annualYear = (year - 1911).to_s
	end
	@annualFielding = Fielding.select('fieldings.*, games.time')
							  .where('fieldings.game_id LIKE "' + annualYear + '__"
								  AND fieldings.player_id = "' + @member.id + '"')
							  .joins('INNER JOIN games ON fieldings.game_id = games.game_id')
							  .order('game_id')
							  
	@annualfrequentposition = Hash.new(0);
	@annualFieldingStatistic = Hash.new(0);
	@annualFieldingStatistic["Time"] = year.to_s + ".09~" + (year + 1).to_s + ".08"
	@annualFieldingStatistic["G"] = @annualFielding.size
	@annualFielding.each do |annualFld|
		@annualFieldingStatistic["INN"] += annualFld.InnOuts
		@annualFieldingStatistic["TC"] += annualFld.PO + annualFld.A + annualFld.E
		@annualFieldingStatistic["A"] += annualFld.A
		@annualFieldingStatistic["PO"] += annualFld.PO
		@annualFieldingStatistic["E"] += annualFld.E
		@annualfrequentposition[annualFld.POS] += annualFld.InnOuts
	end
	
	@annualFieldingStatistic["FPCT"] = (@annualFieldingStatistic["A"] + @annualFieldingStatistic["PO"]) / @annualFieldingStatistic["TC"].to_f
	@annualFieldingStatistic["FPOS"] = @annualfrequentposition
	
	return @annualFieldingStatistic 
  end
  helper_method :fieldingFromYear
  
  def show
	if logged_in?
		@member = Member.find(params[:id])
		
		#member = Member.find('AR')
		#member.birthday = Date.new(1990,8,25)
		#member.birthplaceCH = "高雄市"
		#member.birthplaceEN = "Kaohsiung City"
		#member.high_schoolCH = "台北市立建國高級中學"
		#member.high_schoolEN = "Taipei Municipal Jianguo Senior High School"
		#member.position = "P / 1B"
		#member.bats = "L"
		#member.throws = "L"
		#member.save
		
		if(Time.now.year < 2011)
			if Time.now.month >= 9
				@academicYear = '0' + (Time.now.year - 1911).to_s
				@thisyear = Time.now.year
			else
				@academicYear = '0' + (Time.now.year - 1912).to_s
				@thisyear = Time.now.year - 1
			end
		else
			if Time.now.month >= 9
				@academicYear = (Time.now.year - 1912).to_s
				@thisyear = Time.now.year
			else
				@academicYear = (Time.now.year - 1912).to_s
				@thisyear = Time.now.year - 1
			end
		end
		
		if @member.birthday != nil
			birthtime = Time.parse(@member.birthday.to_s)
			@birthdayEN = birthtime.strftime("%B %d#{birthtime.day.ordinal}, %Y")
			@birthdayCH = dateEN2CH(birthtime)
			horoscope = date2Horoscope(birthtime)
			@horoscopeEN = horoscope[0]
			@horoscopeCH = horoscope[1]
		end
		
		if @member.position != nil
			@position = @member.position.split('/')
			@positionEN = Array.new(@position.size)
			@positionCH = Array.new(@position.size)
			@counter = 0
			@position.each do |pos|
				case pos.strip # 去掉可能存在的前後空白
					when 'P'
						@positionEN[@counter] = "Pitcher"
						@positionCH[@counter] = "投手"
					when 'C'
						@positionEN[@counter] = "Catcher"
						@positionCH[@counter] = "捕手"
					when '1B'
						@positionEN[@counter] = "First Baseman"
						@positionCH[@counter] = "一壘手"
					when '2B'
						@positionEN[@counter] = "Second Baseman"
						@positionCH[@counter] = "二壘手"
					when '3B'
						@positionEN[@counter] = "Third Baseman"
						@positionCH[@counter] = "三壘手"
					when 'SS'
						@positionEN[@counter] = "Shortstop"
						@positionCH[@counter] = "游擊手"
					when 'LF'
						@positionEN[@counter] = "Left Fielder"
						@positionCH[@counter] = "左外野手"
					when 'CF'
						@positionEN[@counter] = "Center Fielder"
						@positionCH[@counter] = "中堅手"
					when 'RF'
						@positionEN[@counter] = "Right Fielder"
						@positionCH[@counter] = "右外野手"
					when 'SF'
						@positionEN[@counter] = "Short Fielder"
						@positionCH[@counter] = "自由手"
					when 'IF'
						@positionEN[@counter] = "Infielder"
						@positionCH[@counter] = "內野手"
					when 'OF'
						@positionEN[@counter] = "Outfielder"
						@positionCH[@counter] = "外野手"
					when 'UTIL'
						@positionEN[@counter] = "Utility Player"
						@positionCH[@counter] = "工具人"
					when 'DH'
						@positionEN[@counter] = "Designated Hitter"
						@positionCH[@counter] = "指定打擊"
					when 'MGR'
						@positionEN[@counter] = "Manager"
						@positionCH[@counter] = "經理"
					when 'Pho'
						@positionEN[@counter] = "Photographer"
						@positionCH[@counter] = "攝影師"
					else
						@positionEN[@counter] = pos
						@positionCH[@counter] = pos
				end
				@counter += 1
			end
			else
				@positionEN = Array.new(1)
				@positionCH = Array.new(1)
				@positionEN[0] = "Undecided"
				@positionCH[0] = "未定"
		end
		
		@acdmcPitching = Pitching.select('pitchings.*, games.time')
								 .where('pitchings.game_id LIKE "' + @academicYear + '__"
									 AND pitchings.player_id = "' + @member.id + '"')
								 .joins('INNER JOIN games ON pitchings.game_id = games.game_id')
								 .order('game_id')
		@acdmcBatting = Batting.select('battings.*, games.time')
							   .where('battings.game_id LIKE "' + @academicYear + '__"
								   AND battings.player_id = "' + @member.id + '"')
							   .joins('INNER JOIN games ON battings.game_id = games.game_id')
							   .order('game_id')
		@acdmcFielding = Fielding.select('fieldings.*, games.time')
								 .where('fieldings.game_id LIKE "' + @academicYear + '__"
									 AND fieldings.player_id = "' + @member.id + '"')
								 .joins('INNER JOIN games ON fieldings.game_id = games.game_id')
								 .order('game_id')
		@careerPitching_findyear = Game.select('DISTINCT cups.year')
									   .where('pitchings.player_id = "' + @member.id + '"')
									   .joins('INNER JOIN pitchings ON pitchings.game_id = games.game_id')
									   .joins('INNER JOIN cups ON cups.cup_id = games.cup_id')
		@careerBatting_findyear = Game.select('DISTINCT cups.year')
									  .where('battings.player_id = "' + @member.id + '"')
									  .joins('INNER JOIN battings ON battings.game_id = games.game_id')
									  .joins('INNER JOIN cups ON cups.cup_id = games.cup_id')
		@careerFielding_findyear = Game.select('DISTINCT cups.year')
									   .where('fieldings.player_id = "' + @member.id + '"')
									   .joins('INNER JOIN fieldings ON fieldings.game_id = games.game_id')
									   .joins('INNER JOIN cups ON cups.cup_id = games.cup_id')						 
    
	else
		redirect_to :action => 'new', :controller => 'sessions'
    end
  end
  
end