class RecordsController < ApplicationController
	def index
	
		if logged_in?

			#member = Member.find('shilamus')
			#member.nameEN = "HUANG, Chun-szu"
			#member.birthday = Date.new(1993,2,16)
			#member.birthplaceCH = "台北市"
			#member.birthplaceEN = "Taipei  City"
			#member.high_schoolCH = "台北市私立延平高級中學"
			#member.high_schoolEN = "Yan Ping High School"
			#member.position = "P"
			#member.bats = "R"
			#member.throws = "R"
			#member.save
			
		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
	def game
	
		if logged_in?

			@year = params[:year]
			@game_id = params[:game_id]
			
			if @year == nil && @game_id == nil
				@year_option = Array.new
				@allyear = Cup.select('DISTINCT cups.year').order('cups.year')
				@allyear.each do |eachyear|
					@year_option.push([eachyear.year.to_s + "(" + (eachyear.year - 1911).to_s + "年度)",eachyear.year])
				end
			elsif @year != nil && @game_id == nil 
				@game_oneyear = Game.find_by_sql('SELECT G.game_id,
														 C.year,
														 C.cup_name,
														 teamAway.team_name AS teamAwayName,
														 G.away_score,
														 G.home_score,
														 teamHome.team_name AS teamHomeName,
														 G.time,
														 G.mvp
													FROM games AS G, 
														 cups AS C, 
														 teams AS teamHome,
														 teams AS teamAway
												   WHERE G.cup_id = C.cup_id AND
														 teamHome.team_id = G.home_team_id AND
														 teamAway.team_id = G.away_team_id AND
														 C.year = "' + @year.to_s + '"
												ORDER BY G.game_id')
			else
				
				@winner = ""
				@loser = ""
				@saver = ""
				@game_onegame = Game.find_by_sql('SELECT G.game_id,
														 C.year,
														 C.cup_name,
														 teamAway.team_name AS teamAwayName,
														 teamAway.team_id AS teamAwayID,
														 G.away_score,
														 G.home_score,
														 teamHome.team_name AS teamHomeName,
														 teamHome.team_id AS teamHomeID,
														 G.time,
														 G.mvp
													FROM games AS G, 
														 cups AS C, 
														 teams AS teamHome,
														 teams AS teamAway
												   WHERE G.cup_id = C.cup_id AND
														 teamHome.team_id = G.home_team_id AND
														 teamAway.team_id = G.away_team_id AND
														 G.game_id = "' + @game_id + '"')[0]
				@game_BattingAway = Batting.find_by_sql('SELECT BAT.team_id,
																BAT.order,
																BAT.player_id,
																(BAT.AB+BAT.BB+BAT.IBB+BAT.SF) AS PA,
																BAT.AB,
																BAT.H,
																BAT.B2,
																BAT.B3,
																BAT.HR,
																(BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3) AS TB,
																BAT.RBI,
																BAT.R,
																BAT.SO,
																BAT.BB,
																BAT.IBB,
																BAT.SF,
																BAT.E,
																CAST(CAST((BAT.H/(BAT.AB+0.0000000000000000000000000000000000001)*1000) AS SIGNED) AS DECIMAL)/1000.0 AS AVG
														   FROM battings AS BAT 
														  WHERE BAT.game_id = "' + @game_id + '" AND
																BAT.team_id = "' + @game_onegame.teamAwayID + '"
													   ORDER BY BAT.order')
				@game_AllBattingAway = Batting.find_by_sql('SELECT BAT.team_id,
																   SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																   SUM(BAT.AB) AS AB,
																   SUM(BAT.H) AS H,
																   SUM(BAT.B2) AS B2,
																   SUM(BAT.B3) AS B3,
																   SUM(BAT.HR) AS HR,
																   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																   SUM(BAT.RBI) AS RBI,
																   SUM(BAT.R) AS R,
																   SUM(BAT.SO) AS SO,
																   SUM(BAT.BB) AS BB,
																   SUM(BAT.IBB) AS IBB,
																   SUM(BAT.SF) AS SF,
																   SUM(BAT.E) AS E,
																   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*1000) AS SIGNED) AS DECIMAL)/1000.0 AS AVG
															  FROM battings AS BAT
															 WHERE BAT.game_id = "' + @game_id + '" AND
																   BAT.team_id = "' + @game_onegame.teamAwayID + '"')[0]
				@game_BattingHome = Batting.find_by_sql('SELECT BAT.team_id,
																BAT.order,
																BAT.player_id,
																(BAT.AB+BAT.BB+BAT.IBB+BAT.SF) AS PA,
																BAT.AB,
																BAT.H,
																BAT.B2,
																BAT.B3,
																BAT.HR,
																(BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3) AS TB,
																BAT.RBI,
																BAT.R,
																BAT.SO,
																BAT.BB,
																BAT.IBB,
																BAT.SF,
																BAT.E,
																CAST(CAST((BAT.H/(BAT.AB+0.0000000000000000000000000000000000001)*1000) AS SIGNED) AS DECIMAL)/1000.0 AS AVG
														   FROM battings AS BAT 
														  WHERE BAT.game_id = "' + @game_id + '" AND
																BAT.team_id = "' + @game_onegame.teamHomeID + '"
													   ORDER BY BAT.order')
				@game_AllBattingHome = Batting.find_by_sql('SELECT BAT.team_id,
																   SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																   SUM(BAT.AB) AS AB,
																   SUM(BAT.H) AS H,
																   SUM(BAT.B2) AS B2,
																   SUM(BAT.B3) AS B3,
																   SUM(BAT.HR) AS HR,
																   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																   SUM(BAT.RBI) AS RBI,
																   SUM(BAT.R) AS R,
																   SUM(BAT.SO) AS SO,
																   SUM(BAT.BB) AS BB,
																   SUM(BAT.IBB) AS IBB,
																   SUM(BAT.SF) AS SF,
																   SUM(BAT.E) AS E,
																   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*1000) AS SIGNED) AS DECIMAL)/1000.0 AS AVG
															  FROM battings AS BAT
															 WHERE BAT.game_id = "' + @game_id + '" AND
																   BAT.team_id = "' + @game_onegame.teamHomeID + '"')[0]
				@game_PitchingAway = Pitching.find_by_sql('SELECT PIT.team_id,
																  PIT.player_id,
																  CAST(PIT.IPouts/3.0*10 AS DECIMAL)/10 AS IP,
																  PIT.BAOpp,
																  PIT.H,
																  PIT.HR,
																  PIT.SO,
																  PIT.BB,
																  PIT.IBB,
																  PIT.R,
																  PIT.ER,
																  CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*100 AS SIGNED) AS DECIMAL)/100.0 AS ERA5,
																  CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*100 AS SIGNED) AS DECIMAL)/100.0 AS ERA7,
																  PIT.W,
																  PIT.L,
																  PIT.SV
															 FROM pitchings AS PIT 
															WHERE PIT.game_id = "' + @game_id + '" AND
																  PIT.team_id = "' + @game_onegame.teamAwayID + '"
														 ORDER BY PIT.order')
				@game_AllPitchingAway = Pitching.find_by_sql('SELECT PIT.team_id,
																	 CAST(SUM(PIT.IPouts)/3.0*10 AS DECIMAL)/10 AS IP,
																	 SUM(PIT.BAOpp) AS BAOpp,
																	 SUM(PIT.H) AS H,
																	 SUM(PIT.HR) AS HR,
																	 SUM(PIT.SO) AS SO,
																	 SUM(PIT.BB) AS BB,
																	 SUM(PIT.IBB) AS IBB,
																	 SUM(PIT.R) AS R,
																	 SUM(PIT.ER) AS ER,
																	 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*100 AS SIGNED) AS DECIMAL)/100.0 AS ERA5,
																	 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*100 AS SIGNED) AS DECIMAL)/100.0 AS ERA7
																FROM pitchings AS PIT
															   WHERE PIT.game_id = "' + @game_id + '" AND
																	 PIT.team_id = "' + @game_onegame.teamAwayID + '"')[0]
				@game_PitchingHome = Pitching.find_by_sql('SELECT PIT.team_id,
																  PIT.player_id,
																  CAST(PIT.IPouts/3.0*10 AS DECIMAL)/10 AS IP,
																  PIT.BAOpp,
																  PIT.H,
																  PIT.HR,
																  PIT.SO,
																  PIT.BB,
																  PIT.IBB,
																  PIT.R,
																  PIT.ER,
																  CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*100 AS SIGNED) AS DECIMAL)/100.0 AS ERA5,
																  CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*100 AS SIGNED) AS DECIMAL)/100.0 AS ERA7,
																  PIT.W,
																  PIT.L,
																  PIT.SV
															 FROM pitchings AS PIT 
															WHERE PIT.game_id = "' + @game_id + '" AND
																  PIT.team_id = "' + @game_onegame.teamHomeID + '"
														 ORDER BY PIT.order')
				@game_AllPitchingHome = Pitching.find_by_sql('SELECT PIT.team_id,
																	 CAST(SUM(PIT.IPouts)/3.0*10 AS DECIMAL)/10 AS IP,
																	 SUM(PIT.BAOpp) AS BAOpp,
																	 SUM(PIT.H) AS H,
																	 SUM(PIT.HR) AS HR,
																	 SUM(PIT.SO) AS SO,
																	 SUM(PIT.BB) AS BB,
																	 SUM(PIT.IBB) AS IBB,
																	 SUM(PIT.R) AS R,
																	 SUM(PIT.ER) AS ER,
																	 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*100 AS SIGNED) AS DECIMAL)/100.0 AS ERA5,
																	 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*100 AS SIGNED) AS DECIMAL)/100.0 AS ERA7
																FROM pitchings AS PIT
															   WHERE PIT.game_id = "' + @game_id + '" AND
																	 PIT.team_id = "' + @game_onegame.teamHomeID + '"')[0]
				@game_FieldingAway = Fielding.find_by_sql('SELECT FIELD.team_id,
																  FIELD.POS,
																  FIELD.player_id,
																  CAST(FIELD.InnOuts/3.0*10 AS DECIMAL)/10 AS INN,
																  FIELD.PO+FIELD.K+FIELD.A+FIELD.E AS TC,
																  FIELD.PO,
																  FIELD.K,
																  FIELD.A,
																  FIELD.E,
																  CAST(CAST((FIELD.PO+FIELD.K+FIELD.A)/(FIELD.PO+FIELD.K+FIELD.A+FIELD.E+0.000000000000000000000000000001)*1000 AS SIGNED) AS DECIMAL)/1000.0 AS FPCT
															 FROM fieldings AS FIELD,
																  positions AS POSITION
															WHERE FIELD.POS = POSITION.POS AND
																  FIELD.game_id = "' + @game_id + '" AND
																  FIELD.team_id = "' + @game_onegame.teamAwayID + '"
														 ORDER BY POSITION.pos_num,
																  FIELD.player_id')
				@game_AllFieldingAway = Fielding.find_by_sql('SELECT FIELD.team_id,
																	 SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																	 SUM(FIELD.PO) AS PO,
																	 SUM(FIELD.K) AS K,
																	 SUM(FIELD.A) AS A,
																	 SUM(FIELD.E) AS E,
																	 CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A)+SUM(FIELD.E)+0.00000000000000000000000000000000001)*1000 AS SIGNED) AS DECIMAL)/1000.0 AS FPCT
																FROM fieldings AS FIELD
															   WHERE FIELD.game_id = "' + @game_id + '" AND
																	 FIELD.team_id = "' + @game_onegame.teamAwayID + '"')[0]
				@game_FieldingHome = Fielding.find_by_sql('SELECT FIELD.team_id,
																  FIELD.POS,
																  FIELD.player_id,
																  CAST(FIELD.InnOuts/3.0*10 AS DECIMAL)/10 AS INN,
																  FIELD.PO+FIELD.K+FIELD.A+FIELD.E AS TC,
																  FIELD.PO,
																  FIELD.K,
																  FIELD.A,
																  FIELD.E,
																  CAST(CAST((FIELD.PO+FIELD.K+FIELD.A)/(FIELD.PO+FIELD.K+FIELD.A+FIELD.E+0.000000000000000000000000000001)*1000 AS SIGNED) AS DECIMAL)/1000.0 AS FPCT
															 FROM fieldings AS FIELD,
																  positions AS POSITION
															WHERE FIELD.POS = POSITION.POS AND
																  FIELD.game_id = "' + @game_id + '" AND
																  FIELD.team_id = "' + @game_onegame.teamHomeID + '"
														 ORDER BY POSITION.pos_num,
																  FIELD.player_id')
				@game_AllFieldingHome = Fielding.find_by_sql('SELECT FIELD.team_id,
																	 SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																	 SUM(FIELD.PO) AS PO,
																	 SUM(FIELD.K) AS K,
																	 SUM(FIELD.A) AS A,
																	 SUM(FIELD.E) AS E,
																	 CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A)+SUM(FIELD.E)+0.00000000000000000000000000000000001)*1000 AS SIGNED) AS DECIMAL)/1000.0 AS FPCT
																FROM fieldings AS FIELD
															   WHERE FIELD.game_id = "' + @game_id + '" AND
																	 FIELD.team_id = "' + @game_onegame.teamHomeID + '"')[0]
				if @game_PitchingAway.size != 0
					@game_PitchingAway.each do |pitAway|
						if pitAway.W == 1
							@winner = pitAway.player_id
						end
						if pitAway.L == 1
							@loser = pitAway.player_id
						end
						if pitAway.SV == 1
							@saver = pitAway.player_id
						end
					end
				end
				if @game_PitchingHome.size != 0
					@game_PitchingHome.each do |pitHome|
						if pitHome.W == 1
							@winner = pitHome.player_id
						end
						if pitHome.L == 1
							@loser = pitHome.player_id
						end
						if pitHome.SV == 1
							@saver = pitHome.player_id
						end
					end
				end
			end
			
		else
			session[:return_to] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
	def playersInYear(year,type)
		
		if type == 'Batting'
			if year == "Wildcard"
				@playerInThisYear = Batting.find_by_sql('SELECT DISTINCT BAT.player_id
														   FROM battings AS BAT,
																players AS PLY
														  WHERE BAT.player_id = PLY.player_id AND
																PLY.member = 1
													   ORDER BY BAT.player_id')
			else
				@playerInThisYear = Batting.find_by_sql('SELECT DISTINCT BAT.player_id
														   FROM battings AS BAT,
																players AS PLY
														  WHERE BAT.player_id = PLY.player_id AND
																PLY.member = 1 AND
																BAT.game_id IN (SELECT G.game_id 
																				  FROM battings AS BAT,
																					   games AS G,
																					   cups AS C
																				 WHERE BAT.game_id = G.game_id AND
																					   G.cup_id = C.cup_id AND
																					   C.year = "' + year.to_s + '")
													   ORDER BY BAT.player_id')
			end
		elsif type == 'Pitching'
			if year == "Wildcard"
				@playerInThisYear = Batting.find_by_sql('SELECT DISTINCT PIT.player_id
														   FROM pitchings AS PIT,
																players AS PLY
														  WHERE PIT.player_id = PLY.player_id AND
																PLY.member = 1
													   ORDER BY PIT.player_id')
			else
				@playerInThisYear = Batting.find_by_sql('SELECT DISTINCT PIT.player_id
														   FROM pitchings AS PIT,
																players AS PLY
														  WHERE PIT.player_id = PLY.player_id AND
																PLY.member = 1 AND
																PIT.game_id IN (SELECT G.game_id 
																				  FROM pitchings AS PIT,
																					   games AS G,
																					   cups AS C
																				 WHERE PIT.game_id = G.game_id AND
																					   G.cup_id = C.cup_id AND
																					   C.year = "' + year.to_s + '")
													   ORDER BY PIT.player_id')
			end
		elsif type == 'Fielding'
			if year == "Wildcard"
				@playerInThisYear = Batting.find_by_sql('SELECT DISTINCT FIELD.player_id
														   FROM fieldings AS FIELD,
																players AS PLY
														  WHERE FIELD.player_id = PLY.player_id AND
																PLY.member = 1
													   ORDER BY FIELD.player_id')
			else
				@playerInThisYear = Batting.find_by_sql('SELECT DISTINCT FIELD.player_id
														   FROM fieldings AS FIELD,
																players AS PLY
														  WHERE FIELD.player_id = PLY.player_id AND
																PLY.member = 1 AND 
																FIELD.game_id IN (SELECT G.game_id 
																					FROM fieldings AS FIELD,
																						 games AS G,
																						 cups AS C
																				   WHERE FIELD.game_id = G.game_id AND
																						 G.cup_id = C.cup_id AND
																						 C.year = "' + year.to_s + '")
													   ORDER BY FIELD.player_id')
			end
		end
		
		return @playerInThisYear
	end
	helper_method :playersInYear
	
	def batting
		
		if logged_in?
		
			@activePLAYER_rate = 1
			@activePLAYER = 150
			# 每年有幾場比賽
			@gameNumberInEachYear = Cup.find_by_sql('SELECT cups.year,
															COUNT(*) AS gameNumber
													   FROM games,
															cups
													  WHERE games.cup_id = cups.cup_id
												   GROUP BY cups.year')
			@gameNumberInYear = Hash.new(0)
			@gameNumberInWildcard = 0
			@gameNumberInEachYear.each do |gNIEY|
				@gameNumberInYear[gNIEY.year.to_s] = gNIEY.gameNumber
				@gameNumberInWildcard += gNIEY.gameNumber
			end
			@gameNumberInYear['Wildcard'] = @gameNumberInWildcard
			
			@type = params[:type]
			@cup = params[:cup]
			@year = params[:year]
			@year1 = params[:year1]
			@year2 = params[:year2]
			@player = params[:player]
			@player1 = params[:player1]
			@player2 = params[:player2]
			@sortBy = (params[:sortBy] == nil)? ('AVG'):(params[:sortBy])
			
			if @type == 'single'
				@player = params[:player1]
				@year = params[:year1]
			elsif @type == 'pk'
				if params[:player1] == params[:player2] && params[:year1] == params[:year2]
					@player = params[:player1]
					@year = params[:year1]
				elsif params[:player2] == nil
					@player = params[:player1]
					@year = params[:year1]
				else
					@player = "pk"
					@year = "pk"
				end
			end
			
			@sql_year = ' '
			# 別頁傳入cup參數導入此頁時會用到
			if @year != nil && @year != 'Wildcard' && @cup == nil # 年份不是選不分年度且盃賽為空
				@sql_year = ' AND BAT.game_id IN (SELECT DISTINCT G.game_id
												   FROM battings AS BAT,
														games AS G, 
														cups AS C
												  WHERE BAT.game_id = G.game_id AND
														G.cup_id = C.cup_id AND
														C.year = ' + @year.to_s + ') '
			elsif @year == 'Wildcard' && @cup != nil # 年份選不分年度且盃賽不為空
				if @cup == '官方賽'
					@sql_year = ' AND BAT.game_id IN (SELECT DISTINCT G.game_id
												   FROM battings AS BAT,
														games AS G, 
														cups AS C
												  WHERE BAT.game_id = G.game_id AND
														G.cup_id = C.cup_id AND
														C.official = 1) '
				elsif @cup == '正式賽'
					@sql_year = ' AND BAT.game_id IN (SELECT DISTINCT G.game_id
												   FROM battings AS BAT,
														games AS G, 
														cups AS C
												  WHERE BAT.game_id = G.game_id AND
														G.cup_id = C.cup_id AND
														C.formal = 1) '
				else
					@sql_year = ' AND BAT.game_id IN (SELECT DISTINCT G.game_id
													   FROM battings AS BAT,
															games AS G, 
															cups AS C
													  WHERE BAT.game_id = G.game_id AND
															G.cup_id = C.cup_id AND
															C.cup_name = "' + @cup + '") '
				end
			elsif @year != nil && @cup != nil # 年份非空且盃賽非空
				if @cup == '官方賽'
					@sql_year = ' AND BAT.game_id IN (SELECT DISTINCT G.game_id
												   FROM battings AS BAT,
														games AS G, 
														cups AS C
												  WHERE BAT.game_id = G.game_id AND
														G.cup_id = C.cup_id AND
														C.year = ' + @year.to_s + ' AND
														C.official = 1) '
				elsif @cup == '正式賽'
					@sql_year = ' AND BAT.game_id IN (SELECT DISTINCT G.game_id
												   FROM battings AS BAT,
														games AS G, 
														cups AS C
												  WHERE BAT.game_id = G.game_id AND
														G.cup_id = C.cup_id AND
														C.year = ' + @year.to_s + ' AND
														C.formal = 1) '
				else
					@sql_year = ' AND BAT.game_id IN (SELECT DISTINCT G.game_id
												   FROM battings AS BAT,
														games AS G, 
														cups AS C
												  WHERE BAT.game_id = G.game_id AND
														G.cup_id = C.cup_id AND
														C.year = ' + @year.to_s + ' AND
														C.cup_name = "' + @cup + '") '
				end
			end
			
			# 子頁面處理邏輯由此開始
			if @player == nil # 選單頁
				
				@year_option = Array.new
				@allyear = Cup.select('DISTINCT cups.year').order('cups.year')
				@allyear.each do |eachyear|
					@year_option.push([eachyear.year.to_s + "(" + (eachyear.year - 1911).to_s + "年度)",eachyear.year])
				end
				@year_option.push(["不分年度","Wildcard"])
			
			elsif @player == "all" # 選'all'時的全部打擊資料頁
				
				@sorting = params[:sorting]
				if @year == "Wildcard"
					@sql_year = ' '
				else
					@sql_year = ' AND BAT.game_id IN (SELECT G.game_id 
													    FROM battings AS BAT,
															 games AS G,
															 cups AS C 
													   WHERE BAT.game_id = G.game_id AND
															 G.cup_id = C.cup_id AND
															 C.year = "' + @year.to_s + '") '
				end
				@allBatting = Batting.find_by_sql('SELECT BAT.player_id, 
														  COUNT(BAT.game_id) AS G, 
														  SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA, 
														  SUM(BAT.AB) AS AB, 
														  SUM(BAT.H) AS H, 
														  SUM(BAT.B2) AS B2, 
														  SUM(BAT.B3) AS B3, 
														  SUM(BAT.HR) AS HR, 
														  SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB, 
														  SUM(BAT.RBI) AS RBI, 
														  SUM(BAT.R) AS R, 
														  SUM(BAT.SO) AS SO, 
														  SUM(BAT.BB) AS BB, 
														  SUM(BAT.IBB) AS IBB, 
														  SUM(BAT.SF) AS SF, 
														  SUM(BAT.E) AS E, 
														  CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
														  CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
														  CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
														  (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
														  CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA
												     FROM battings AS BAT, 
														  players AS PLY 
												    WHERE BAT.player_id = PLY.player_id AND
														  PLY.member = 1 ' + @sql_year.to_s +
											    'GROUP BY BAT.player_id')
				@mainPlayer = ' AND BAT.player_id IN (SELECT BAT.player_id 
														FROM battings AS BAT 
													   WHERE BAT.game_id <> "0" ' + @sql_year.to_s + 
												   'GROUP BY BAT.player_id 
													  HAVING SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) >= ' + @gameNumberInYear[@year.to_s].to_s + ' OR
															 SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) >= ' + @activePLAYER.to_s + ') '
				@notMainPlayer = ' AND BAT.player_id IN (SELECT BAT.player_id 
														   FROM battings AS BAT
														  WHERE BAT.game_id <> "0" ' + @sql_year.to_s +
													  'GROUP BY BAT.player_id 
													     HAVING SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) < ' + @gameNumberInYear[@year.to_s].to_s + ' AND
																SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) < ' + @activePLAYER.to_s + ') '
				@allBattingSummary_M = Batting.find_by_sql('SELECT SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																   SUM(BAT.AB) AS AB,
																   SUM(BAT.H) AS H,
																   SUM(BAT.B2) AS B2,
																   SUM(BAT.B3) AS B3,
																   SUM(BAT.HR) AS HR,
																   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																   SUM(BAT.RBI) AS RBI,
																   SUM(BAT.R) AS R,
																   SUM(BAT.SO) AS SO,
																   SUM(BAT.BB) AS BB,
																   SUM(BAT.IBB) AS IBB,
																   SUM(BAT.SF) AS SF,
																   SUM(BAT.E) AS E,
																   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																   CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
																   CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
																   (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
																   CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA
															  FROM battings AS BAT,
																   players AS PLY
															 WHERE BAT.player_id = PLY.player_id AND
																   PLY.member = 1 ' + @mainPlayer + @sql_year)[0]
				@allBattingSummary_nM = Batting.find_by_sql('SELECT SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																    SUM(BAT.AB) AS AB,
																    SUM(BAT.H) AS H,
																    SUM(BAT.B2) AS B2,
																    SUM(BAT.B3) AS B3,
																    SUM(BAT.HR) AS HR,
																    SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																    SUM(BAT.RBI) AS RBI,
																    SUM(BAT.R) AS R,
																    SUM(BAT.SO) AS SO,
																    SUM(BAT.BB) AS BB,
																    SUM(BAT.IBB) AS IBB,
																    SUM(BAT.SF) AS SF,
																    SUM(BAT.E) AS E,
																    CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																    CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
																    CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
																    (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
																    CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA
															   FROM battings AS BAT,
																	players AS PLY
															  WHERE BAT.player_id = PLY.player_id AND
																    PLY.member = 1 ' + @notMainPlayer + @sql_year)[0]
				@allBattingSummary_all = Batting.find_by_sql('SELECT SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																     SUM(BAT.AB) AS AB,
																     SUM(BAT.H) AS H,
																     SUM(BAT.B2) AS B2,
																     SUM(BAT.B3) AS B3,
																     SUM(BAT.HR) AS HR,
																     SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																     SUM(BAT.RBI) AS RBI,
																     SUM(BAT.R) AS R,
																     SUM(BAT.SO) AS SO,
																     SUM(BAT.BB) AS BB,
																     SUM(BAT.IBB) AS IBB,
																     SUM(BAT.SF) AS SF,
																     SUM(BAT.E) AS E,
																     CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																     CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
																     CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
																     (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
																     CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA
															    FROM battings AS BAT,
																	 players AS PLY
															   WHERE BAT.player_id = PLY.player_id AND
																     PLY.member = 1 ' + @sql_year)[0]												   
				
			elsif @player == "pk" # 選'Two Players'時的PK打擊資料頁
				@sql_year1 = (@year1 == 'Wildcard')? ('') : (' AND BAT.game_id IN (SELECT G.game_id 
																					 FROM games AS G, 
																					 	  cups AS C
																				    WHERE G.cup_id = C.cup_id AND
																						  C.year = ' + @year1 + ') ')
				@sql_year2 = (@year2 == 'Wildcard')? ('') : (' AND BAT.game_id IN (SELECT G.game_id 
																					 FROM games AS G, 
																						  cups AS C
																				    WHERE G.cup_id = C.cup_id AND
																						  C.year = ' + @year2 + ') ')
				@player1_batting = Batting.find_by_sql('SELECT BAT.player_id,
															   COUNT(BAT.game_id) AS G,
															   SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
															   SUM(BAT.AB) AS AB,
															   SUM(BAT.H) AS H,
															   SUM(BAT.B2) AS B2,
															   SUM(BAT.B3) AS B3,
															   SUM(BAT.HR) AS HR,
															   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
															   SUM(BAT.RBI) AS RBI,
															   SUM(BAT.R) AS R,
															   SUM(BAT.SO) AS SO,
															   SUM(BAT.BB) AS BB,
															   SUM(BAT.IBB) AS IBB,
															   SUM(BAT.SF) AS SF,
															   SUM(BAT.E) AS E,
															   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
															   (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
															   CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA,
													           (CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0)*1000+SUM(BAT.HR)*20+SUM(BAT.RBI)*5+(SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3) AS SILVER
															   FROM battings AS BAT 
															   WHERE BAT.player_id = "' + @player1  + '" ' + @sql_year1 +
															  'GROUP BY BAT.player_id')[0]
				@player2_batting = Batting.find_by_sql('SELECT BAT.player_id,
															   COUNT(BAT.game_id) AS G,
															   SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
															   SUM(BAT.AB) AS AB,
															   SUM(BAT.H) AS H,
															   SUM(BAT.B2) AS B2,
															   SUM(BAT.B3) AS B3,
															   SUM(BAT.HR) AS HR,
															   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
															   SUM(BAT.RBI) AS RBI,
															   SUM(BAT.R) AS R,
															   SUM(BAT.SO) AS SO,
															   SUM(BAT.BB) AS BB,
															   SUM(BAT.IBB) AS IBB,
															   SUM(BAT.SF) AS SF,
															   SUM(BAT.E) AS E,
															   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
															   (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
															   CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA,
													           (CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0)*1000+SUM(BAT.HR)*20+SUM(BAT.RBI)*5+(SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3) AS SILVER
															   FROM battings AS BAT 
															   WHERE BAT.player_id = "' + @player2  + '" ' + @sql_year2 +
															  'GROUP BY BAT.player_id')[0]
				if @player1_batting == nil
					Struct.new("PlayerBatting", :player_id, :G, :PA, :AB, :H, :B2, :B3, :HR, :TB, :RBI, :R, :SO, :BB, :IBB, :SF, :AVG, :OBP, :SLG, :OPS, :TA, :SILVER)
					@player1_batting = Struct::PlayerBatting.new(@player1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
				end
				if @player2_batting == nil
					Struct.new("PlayerBatting", :player_id, :G, :PA, :AB, :H, :B2, :B3, :HR, :TB, :RBI, :R, :SO, :BB, :IBB, :SF, :AVG, :OBP, :SLG, :OPS, :TA, :SILVER)
					@player2_batting = Struct::PlayerBatting.new(@player2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
				end
			else # 個人打擊資料頁
				@playerBattingSummary = Batting.find_by_sql('SELECT BAT.player_id,
																    COUNT(BAT.game_id) AS G,
																    SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																    SUM(BAT.AB) AS AB,
																    SUM(BAT.H) AS H,
																    SUM(BAT.B2) AS B2,
																    SUM(BAT.B3) AS B3,
																    SUM(BAT.HR) AS HR,
																    SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																    SUM(BAT.RBI) AS RBI,
																    SUM(BAT.R) AS R,
																    SUM(BAT.SO) AS SO,
																    SUM(BAT.BB) AS BB,
																    SUM(BAT.IBB) AS IBB,
																    SUM(BAT.SF) AS SF,
																	SUM(BAT.E) AS E,
																    CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																    CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
																    CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
																    (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
																    CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA,
																    (CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0)*1000+SUM(BAT.HR)*20+SUM(BAT.RBI)*5+(SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3) AS SILVER
																    FROM battings AS BAT 
																    WHERE BAT.player_id = "' + @player + '" ' + @sql_year)[0]
				@playerBattingForGraph = Batting.find_by_sql('SELECT BAT.game_id,
																	 (BAT.AB+BAT.BB+BAT.IBB+BAT.SF) AS PA,
																	 BAT.AB,
																	 BAT.H,
																	 BAT.B2,
																	 BAT.B3,
																	 BAT.HR,
																	 (BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3) AS TB,
																	 BAT.RBI,
																	 BAT.R,
																	 BAT.SO,
																	 BAT.BB,
																	 BAT.IBB,
																	 BAT.SF,
																	 BAT.E,
																	 CAST(CAST((BAT.H/(BAT.AB+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																     CAST(CAST(((BAT.H+BAT.BB+BAT.IBB)/(BAT.AB+BAT.BB+BAT.IBB+BAT.SF+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
																     CAST(CAST(((BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3)/(BAT.AB+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
																     (CAST(CAST(((BAT.H+BAT.BB+BAT.IBB)/(BAT.AB+BAT.BB+BAT.IBB+BAT.SF+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3)/(BAT.AB+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS
																FROM battings AS BAT
															   WHERE BAT.player_id = "' + @player + '" ' + @sql_year +
														   'ORDER BY BAT.game_id')
				
				@AVGData = Array.new()
				@OBPData = Array.new()
				@SLGData = Array.new()
				@OPSData = Array.new()
				if @playerBattingForGraph.size != 0
					@AVG_Max = 0
					@AVG_Min = 1
					@totalPA = 0
					@totalAB = 0
					@totalHit = 0
					@totalTB = 0
					@totalBB = 0
					@totalIBB = 0
					@playerBattingForGraph.each_with_index do |pBFG, index|
						@totalPA += pBFG.PA
						@totalAB += pBFG.AB
						@totalHit += pBFG.H
						@totalTB += pBFG.TB
						@totalBB += pBFG.BB
						@totalIBB += pBFG.IBB
						
						# 這裡PA不可能為0
						if @totalAB == 0
							if 0 > @AVG_Max
								@AVG_Max = 0
							end
							if 0 < @AVG_Min
								@AVG_Min = 0
							end
							@AVGData.push([index,0.000])
							@SLGData.push([index,0.000])
						else
							if @totalHit.to_f / @totalAB > @AVG_Max
								@AVG_Max = @totalHit.to_f / @totalAB
							end
							if @totalHit.to_f / @totalAB < @AVG_Min
								@AVG_Min = @totalHit.to_f / @totalAB
							end
							@AVGData.push([index,@totalHit.to_f / @totalAB])
							@SLGData.push([index,@totalTB.to_f / @totalAB])
						end
						@OBPData.push([index,(@totalHit+@totalBB+@totalIBB).to_f / @totalPA])
						@OPSData.push([index, @OBPData[(@OBPData.size - 1)][1] + @SLGData[(@SLGData.size - 1)][1] ])
						
					end
				end
				
				
				
			end
			
			
		
		else
			session[:return_to] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
	def sortHelper(th1,th2,original,digit)
	
		if th1 == 0
			if th2 == 0
				if digit == 1
					return '-.-'
				elsif digit == 2
					return '-.--'
				elsif digit == 3
					return '-.---'
				end
			else
				return '∞'
			end
		else
			return original.round(digit)
		end
	
	end
	helper_method :sortHelper
	
	def pitching
		
		if logged_in?
			
			@activePLAYER_rate = 1
			@activePLAYER = 50
			# 每年有幾場比賽
			@gameNumberInEachYear = Cup.find_by_sql('SELECT cups.year,
															COUNT(*) AS gameNumber
													   FROM games,
															cups
													  WHERE games.cup_id = cups.cup_id
												   GROUP BY cups.year')
			@gameNumberInYear = Hash.new(0)
			@gameNumberInWildcard = 0
			@gameNumberInEachYear.each do |gNIEY|
				@gameNumberInYear[gNIEY.year.to_s] = gNIEY.gameNumber
				@gameNumberInWildcard += gNIEY.gameNumber
			end
			@gameNumberInYear['Wildcard'] = @gameNumberInWildcard
			
			@player = params[:player]
			@year = params[:year]
			@cup = params[:cup]
			@sortBy = (params[:sortBy] == nil)? ('W'):(params[:sortBy])
			@sql_year = ' '
			
			# 別頁傳入cup參數導入此頁時會用到
			if @year != nil && @year != 'Wildcard' && @cup == nil # 年份不是選不分年度且盃賽為空
				@sql_year = ' AND PIT.game_id IN (SELECT DISTINCT G.game_id
													FROM pitchings AS PIT,
														 games AS G, 
														 cups AS C
												   WHERE PIT.game_id = G.game_id AND
														 G.cup_id = C.cup_id AND
														 C.year = ' + @year.to_s + ') '
			elsif @year == 'Wildcard' && @cup != nil # 年份選不分年度且盃賽不為空
				if @cup == '官方賽'
					@sql_year = ' AND PIT.game_id IN (SELECT DISTINCT G.game_id
													FROM pitchings AS PIT,
														 games AS G, 
														 cups AS C
												   WHERE PIT.game_id = G.game_id AND
														 G.cup_id = C.cup_id AND
														 C.official = 1) '
				elsif @cup == '正式賽'
					@sql_year = ' AND PIT.game_id IN (SELECT DISTINCT G.game_id
													FROM pitchings AS PIT,
														 games AS G, 
														 cups AS C
												   WHERE PIT.game_id = G.game_id AND
														 G.cup_id = C.cup_id AND
														 C.formal = 1) '
				else	
					@sql_year = ' AND PIT.game_id IN (SELECT DISTINCT G.game_id
														FROM pitchings AS PIT,
															 games AS G, 
															 cups AS C
													   WHERE PIT.game_id = G.game_id AND
															 G.cup_id = C.cup_id AND
															 C.cup_name = "' + @cup + '") '
				end
			elsif @year != nil && @cup != nil # 年份非空且盃賽非空
				if @cup == '官方賽'
					@sql_year = ' AND PIT.game_id IN (SELECT DISTINCT G.game_id
													FROM pitchings AS PIT,
														 games AS G, 
														 cups AS C
												   WHERE PIT.game_id = G.game_id AND
														 G.cup_id = C.cup_id AND
														 C.year = ' + @year.to_s + ' AND
														 C.official = 1) '
				elsif @cup == '正式賽'
					@sql_year = ' AND PIT.game_id IN (SELECT DISTINCT G.game_id
													FROM pitchings AS PIT,
														 games AS G, 
														 cups AS C
												   WHERE PIT.game_id = G.game_id AND
														 G.cup_id = C.cup_id AND
														 C.year = ' + @year.to_s + ' AND
														 C.formal = 1) '
				else
					@sql_year = ' AND PIT.game_id IN (SELECT DISTINCT G.game_id
													FROM pitchings AS PIT,
														 games AS G, 
														 cups AS C
												   WHERE PIT.game_id = G.game_id AND
														 G.cup_id = C.cup_id AND
														 C.year = ' + @year.to_s + ' AND
														 C.cup_name = "' + @cup + '") '
				end
			end
			
			if @player == nil && @year == nil
			
				@year_option = Array.new
				@allyear = Cup.select('DISTINCT cups.year').order('cups.year')
				@allyear.each do |eachyear|
					@year_option.push([eachyear.year.to_s + "(" + (eachyear.year - 1911).to_s + "年度)",eachyear.year])
				end
				@year_option.push(["不分年度","Wildcard"])
			
			elsif @player == 'all'
				
				@allPitching = Pitching.find_by_sql('SELECT PIT.player_id, 
															COUNT(PIT.game_id) AS G,
															SUM(PIT.W) AS W,
															SUM(PIT.L) AS L,
															SUM(PIT.IPouts/3.0) AS IP,
															SUM(PIT.BAOpp) AS TBF,
															SUM(PIT.H) AS H,
															SUM(PIT.HR) AS HR,
															SUM(PIT.SO) AS SO,
															SUM(PIT.BB) AS BB,
															SUM(PIT.IBB) AS IBB,
															SUM(PIT.R) AS R,
															SUM(PIT.ER) AS ER,
															CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
															(SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
															CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
															CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
															CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R5,
															CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R7
													   FROM pitchings AS PIT, 
															players AS PLY
													  WHERE PLY.player_id = PIT.player_id AND
															PLY.member = 1 ' + @sql_year + 
												  'GROUP BY PIT.player_id
												   ORDER BY SUM(PIT.W)')
				@allPitchingEachYear = Pitching.find_by_sql('SELECT PIT.player_id,
																	C.year,
																	COUNT(PIT.game_id) AS Game,
																	SUM(PIT.W) AS W,
																	SUM(PIT.L) AS L,
																	SUM(PIT.IPouts/3.0) AS IP,
																	SUM(PIT.BAOpp) AS TBF,
																	SUM(PIT.H) AS H,
																	SUM(PIT.HR) AS HR,
																	SUM(PIT.SO) AS SO,
																	SUM(PIT.BB) AS BB,
																	SUM(PIT.IBB) AS IBB,
																	SUM(PIT.R) AS R,
																	SUM(PIT.ER) AS ER,
																	CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																	(SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
																	CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
																	CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
																	CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R5,
																	CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R7
															   FROM pitchings AS PIT, 
																	players AS PLY,
																	games AS G,
																	cups AS C 
															  WHERE PLY.player_id = PIT.player_id AND
																	PIT.game_id = G.game_id AND
																	G.cup_id = C.cup_id AND
																	PLY.member = 1 
														   GROUP BY PIT.player_id,
																	C.year')
				@allPitchingSummary = Pitching.find_by_sql('SELECT SUM(PIT.W) AS W,
															SUM(PIT.L) AS L,
															SUM(PIT.IPouts/3.0) AS IP,
															SUM(PIT.BAOpp) AS TBF,
															SUM(PIT.H) AS H,
															SUM(PIT.HR) AS HR,
															SUM(PIT.SO) AS SO,
															SUM(PIT.BB) AS BB,
															SUM(PIT.IBB) AS IBB,
															SUM(PIT.R) AS R,
															SUM(PIT.ER) AS ER,
															CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
															(SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
															CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
															CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
															CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R5,
															CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R7 
													   FROM pitchings AS PIT,
															players AS PLY 
													  WHERE PIT.player_id = PLY.player_id AND
															PLY.member = 1 ' + @sql_year)[0]
				@allPitchingIP = Pitching.find_by_sql('SELECT PIT.player_id,
															  SUM(PIT.BAOpp)/(SUM(PIT.IPouts)/3.0)*5 AS TBF_5IP,
															  SUM(PIT.BAOpp)/(SUM(PIT.IPouts)/3.0)*7 AS TBF_7IP,
															  SUM(PIT.H)/(SUM(PIT.IPouts)/3.0)*5 AS H_5IP,
															  SUM(PIT.H)/(SUM(PIT.IPouts)/3.0)*7 AS H_7IP,
															  SUM(PIT.HR)/(SUM(PIT.IPouts)/3.0)*5 AS HR_5IP,
															  SUM(PIT.HR)/(SUM(PIT.IPouts)/3.0)*7 AS HR_7IP,
															  SUM(PIT.SO)/(SUM(PIT.IPouts)/3.0)*5 AS SO_5IP,
															  SUM(PIT.SO)/(SUM(PIT.IPouts)/3.0)*7 AS SO_7IP,
															  SUM(PIT.BB)/(SUM(PIT.IPouts)/3.0)*5 AS BB_5IP,
															  SUM(PIT.BB)/(SUM(PIT.IPouts)/3.0)*7 AS BB_7IP,
															  SUM(PIT.IBB)/(SUM(PIT.IPouts)/3.0)*5 AS IBB_5IP,
															  SUM(PIT.IBB)/(SUM(PIT.IPouts)/3.0)*7 AS IBB_7IP,
															  SUM(PIT.R)/(SUM(PIT.IPouts)/3.0)*5 AS R_5IP,
															  SUM(PIT.R)/(SUM(PIT.IPouts)/3.0)*7 AS R_7IP,
															  SUM(PIT.ER)/(SUM(PIT.IPouts)/3.0)*5 AS ER_5IP,
															  SUM(PIT.ER)/(SUM(PIT.IPouts)/3.0)*7 AS ER_7IP,
															  (SUM(PIT.IPouts)/3.0) AS IP
														 FROM pitchings AS PIT,
															  players AS PLY
														WHERE PLY.player_id = PIT.player_id AND
															  PLY.member = 1 ' + @sql_year + 
													'GROUP BY PIT.player_id
													   HAVING SUM(PIT.IPouts) > 0
													 ORDER BY SUM(PIT.ER)/(SUM(PIT.IPouts)/3.0)')
			elsif @player != 'all'
				
				if @year == 'Wildcard'
					@playerPitchingEachYear = Pitching.find_by_sql('SELECT C.year,
																		   COUNT(PIT.game_id) AS G,
																		   SUM(PIT.W) AS W,
																		   SUM(PIT.L) AS L,
																		   SUM(PIT.IPouts/3.0) AS IP,
																		   SUM(PIT.BAOpp) AS TBF,
																		   SUM(PIT.H) AS H,
																		   SUM(PIT.HR) AS HR,
																		   SUM(PIT.SO) AS SO,
																		   SUM(PIT.BB) AS BB,
																		   SUM(PIT.IBB) AS IBB,
																		   SUM(PIT.R) AS R,
																		   SUM(PIT.ER) AS ER,
																		   CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																		   (SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
																		   CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
																		   CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
																		   CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R5,
																		   CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R7
																	  FROM pitchings AS PIT, 
																		   games AS G,
																		   cups AS C 
																	 WHERE PIT.player_id = "' + @player + '" AND
																		   PIT.game_id = G.game_id AND
																		   G.cup_id = C.cup_id
																  GROUP BY C.year')
				end
				
				@playerPitchingSummary = Pitching.find_by_sql('SELECT COUNT(PIT.game_id) AS G,
																	  SUM(PIT.W) AS W,
																	  SUM(PIT.L) AS L,
																	  SUM(PIT.IPouts/3.0) AS IP,
																	  SUM(PIT.BAOpp) AS TBF,
																	  SUM(PIT.H) AS H,
																	  SUM(PIT.HR) AS HR,
																	  SUM(PIT.SO) AS SO,
																	  SUM(PIT.BB) AS BB,
																	  SUM(PIT.IBB) AS IBB,
																	  SUM(PIT.R) AS R,
																	  SUM(PIT.ER) AS ER,
																	  CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																	  (SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
																	  CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
																	  CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
																	  CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R5,
																	  CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R7
																 FROM pitchings AS PIT
																WHERE PIT.player_id = "' + @player + '" ' + @sql_year)[0]
				@playerPitchingForGraph = Pitching.find_by_sql('SELECT PIT.game_id,
																	   PIT.W,
																	   PIT.L,
																	   PIT.IPouts,
																	   PIT.IPouts/3.0 AS IP,
																	   PIT.BAOpp AS TBF,
																	   PIT.H AS H,
																	   PIT.HR AS HR,
																	   PIT.SO AS SO,
																	   PIT.BB AS BB,
																	   PIT.IBB AS IBB,
																	   PIT.R AS R,
																	   PIT.ER AS ER,
																	   CAST(CAST((PIT.H/(PIT.BAOpp-PIT.BB-PIT.IBB+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																	   (PIT.H+PIT.BB+PIT.IBB+0.0)/(PIT.IPouts+0.0000000000000000000000000000000000001)*3 AS WHIP,
																	   CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
																	   CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
																	   CAST(CAST(PIT.R/(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R5,
																	   CAST(CAST(PIT.R/(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R7
																  FROM pitchings AS PIT,
																	   games AS G,
																	   cups AS C
																 WHERE PIT.player_id = "' + @player + '" AND 
																	   C.cup_id = G.cup_id AND
																	   PIT.game_id = G.game_id ' + @sql_year + 
															 'ORDER BY PIT.game_id')
				@ERA5Data = Array.new()
				@ERA7Data = Array.new()
				if @playerPitchingForGraph.size != 0
					@ERA5_Max = 0
					@ERA5_Min = Float::INFINITY
					@ERA7_Max = 0
					@ERA7_Min = Float::INFINITY
					@totalER = 0
					@totalIPOuts = 0
					@playerPitchingForGraph.each_with_index do |pPFG, index|
						@totalER += pPFG.ER
						@totalIPOuts += pPFG.IPouts
						
						if @totalIPOuts == 0
							if @totalER == 0
								if 0 > @ERA5_Max
									@ERA5_Max = 0
								end
								if 0 < @ERA5_Min
									@ERA5_Min = 0
								end
								if 0 > @ERA7_Max
									@ERA7_Max = 0
								end
								if 0 < @ERA7_Min
									@ERA7_Min = 0
								end
								@ERA5Data.push([index,0.000])
								@ERA7Data.push([index,0.000])
							else
								@ERA5_Max = Float::INFINITY
								@ERA7_Max = Float::INFINITY
								@ERA5Data.push([index,Float::INFINITY])
								@ERA7Data.push([index,Float::INFINITY])
							end
						else
							if @totalER.to_f / @totalIPOuts * 15 > @ERA5_Max
								@ERA5_Max = @totalER.to_f / @totalIPOuts * 15
							end
							if @totalER.to_f / @totalIPOuts * 15 < @ERA5_Min
								@ERA5_Min = @totalER.to_f / @totalIPOuts * 15
							end
							if @totalER.to_f / @totalIPOuts * 21 > @ERA7_Max
								@ERA7_Max = @totalER.to_f / @totalIPOuts * 21
							end
							if @totalER.to_f / @totalIPOuts * 21 < @ERA7_Min
								@ERA7_Min = @totalER.to_f / @totalIPOuts * 21
							end
							@ERA5Data.push([index,@totalER.to_f / @totalIPOuts * 15])
							@ERA7Data.push([index,@totalER.to_f / @totalIPOuts * 21])
						end
					end
				end
			end
			
		
		else
			session[:return_to] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
	def fielding
		if logged_in?
			
			@activePOS_rate = 1.5
			@activePOS = 100
			@activePLAYER_rate = 2
			@activePLAYER = 200
			# 每年有幾場比賽
			@gameNumberInEachYear = Cup.find_by_sql('SELECT cups.year,
															COUNT(*) AS gameNumber
													   FROM games,
															cups
													  WHERE games.cup_id = cups.cup_id
												   GROUP BY cups.year')
			@gameNumberInYear = Hash.new(0)
			@gameNumberInWildcard = 0
			@gameNumberInEachYear.each do |gNIEY|
				@gameNumberInYear[gNIEY.year.to_s] = gNIEY.gameNumber
				@gameNumberInWildcard += gNIEY.gameNumber
			end
			@gameNumberInYear['Wildcard'] = @gameNumberInWildcard
			
			@player = params[:player]
			@year = params[:year]
			@cup = params[:cup]
			@sql_year = ''
			
			if @year != nil && @year != 'Wildcard'
				@sql_year = ' AND FIELD.game_id IN (SELECT G.game_id 
													 FROM fieldings AS FIELD, 
														  games AS G,
														  cups AS C
													WHERE FIELD.game_id = G.game_id AND
														  G.cup_id = C.cup_id AND
														  C.year = ' + @year.to_s + ') '
			elsif @year == 'Wildcard' && @cup != nil
				if @cup == '官方賽'
					@sql_year = ' AND FIELD.game_id IN (SELECT G.game_id 
														 FROM fieldings AS FIELD,
															  games AS G, 
															  cups AS C
														WHERE FIELD.game_id = G.game_id AND
															  G.cup_id = C.cup_id AND
															  C.official = 1) '
				elsif @cup == '正式賽'
					@sql_year = ' AND FIELD.game_id IN (SELECT G.game_id 
														 FROM fieldings AS FIELD,
															  games AS G, 
															  cups AS C
														WHERE FIELD.game_id = G.game_id AND
															  G.cup_id = C.cup_id AND
															  C.formal = 1) '
				else	
					@sql_year = ' AND FIELD.game_id IN (SELECT G.game_id 
														 FROM fieldings AS FIELD,
															  games AS G, 
															  cups AS C
														WHERE FIELD.game_id = G.game_id AND
															  G.cup_id = C.cup_id AND
															  C.cup_name = "' + @cup + '") '
				end
			elsif @year != nil && @cup != nil
				if @cup == '官方賽'
					@sql_year = ' AND FIELD.game_id IN (SELECT G.game_id 
														 FROM fieldings AS FIELD,
															  games AS G, 
															  cups AS C
														WHERE FIELD.game_id = G.game_id AND
															  G.cup_id = C.cup_id AND
															  C.year = ' + @year.to_s + 'AND
															  C.official = 1) '
				elsif @cup == '正式賽'
					@sql_year = ' AND FIELD.game_id IN (SELECT G.game_id 
														 FROM fieldings AS FIELD,
															  games AS G, 
															  cups AS C
														WHERE FIELD.game_id = G.game_id AND
															  G.cup_id = C.cup_id AND
															  C.year = ' + @year.to_s + 'AND
															  C.formal = 1) '
				else
					@sql_year = ' AND FIELD.game_id IN (SELECT G.game_id 
														 FROM fieldings AS FIELD,
															  games AS G, 
															  cups AS C
														WHERE FIELD.game_id = G.game_id AND
															  G.cup_id = C.cup_id AND
															  C.year = ' + @year.to_s + 'AND
															  C.cup_name = "' + @cup + '") '
				end
			end
			
			if @player == nil && @year == nil
				@year_option = Array.new
				@allyear = Cup.select('DISTINCT cups.year').order('cups.year')
				@allyear.each do |eachyear|
					@year_option.push([eachyear.year.to_s + "(" + (eachyear.year - 1911).to_s + "年度)",eachyear.year])
				end
				@year_option.push(["不分年度","Wildcard"])
			elsif @player == 'all'
				@allFieldingPOS = Fielding.find_by_sql('SELECT FIELD.player_id,
															   FIELD.POS,
															   COUNT(FIELD.game_id) AS G,
															   SUM(FIELD.Innouts/3.0) AS INN,
															   SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
															   SUM(FIELD.PO) AS PO,
															   SUM(FIELD.A) AS A,
															   SUM(FIELD.E) AS E,
															   CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT,
															   (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*5 AS Factor5,
															   (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*7 AS Factor7
														  FROM fieldings AS FIELD,
															   players AS PLY,
															   positions AS POSITION
														 WHERE FIELD.player_id = PLY.player_id AND
															   POSITION.POS = FIELD.POS AND
															   PLY.member = 1 ' + @sql_year + 
													 'GROUP BY FIELD.player_id,
															   FIELD.POS,
															   POSITION.pos_num
													  ORDER BY POSITION.pos_num,
															   CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 DESC,
															   (SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)) DESC')
				@allFielding = Fielding.find_by_sql('SELECT FIELD.player_id,
															COUNT(FIELD.game_id) AS G,
															SUM(FIELD.Innouts/3.0) AS INN,
															SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
															SUM(FIELD.PO) AS PO,
															SUM(FIELD.A) AS A,
															SUM(FIELD.E) AS E,
															CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT,
															(SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*5 AS Factor5,
															(SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*7 AS Factor7
													   FROM fieldings AS FIELD,
															players AS PLY 
													  WHERE FIELD.player_id = PLY.player_id AND
															PLY.member = 1 ' + @sql_year + 
												  'GROUP BY FIELD.player_id
												   ORDER BY CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 DESC,
															SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC')
				@allFieldingSummary = Fielding.find_by_sql('SELECT FIELD.POS,
																   SUM(FIELD.Innouts/3.0) AS INN,
																   SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																   SUM(FIELD.PO) AS PO,
																   SUM(FIELD.A) AS A,
																   SUM(FIELD.E) AS E,
																   CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT,
																   (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*5 AS Factor5,
																   (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*7 AS Factor7
															  FROM fieldings AS FIELD,
																   players AS PLY
															 WHERE FIELD.player_id = PLY.player_id AND
																   PLY.member = 1 ' + @sql_year +
														 'GROUP BY UPPER(FIELD.POS)
														  ORDER BY CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 DESC,
																   SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC')
				@allFieldingSummaryTotal = Fielding.find_by_sql('SELECT SUM(FIELD.Innouts/3.0) AS INN,
																		SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																		SUM(FIELD.PO) AS PO,
																		SUM(FIELD.A) AS A,
																		SUM(FIELD.E) AS E,
																		CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT,
																		(SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*5 AS Factor5,
																		(SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*7 AS Factor7
																   FROM fieldings AS FIELD,
																		players AS PLY
																  WHERE FIELD.player_id = PLY.player_id AND
																		PLY.member = 1 ' + @sql_year +
															  'ORDER BY CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 DESC,
																		SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC')[0]
			elsif @year == 'Wildcard' && @player != 'all'
				@playerFieldingByYearAndPos = Fielding.find_by_sql('SELECT C.year AS year,
																		   FIELD.POS AS POS,
																		   COUNT(*) AS G,
																		   SUM(FIELD.Innouts/3.0) AS INN,
																		   SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																		   SUM(FIELD.PO) AS PO,
																		   SUM(FIELD.A) AS A,
																		   SUM(FIELD.E) AS E,
																		   CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT,
																		   (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*5 AS Factor5,
																		   (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*7 AS Factor7
																	  FROM fieldings AS FIELD,
																		   games AS G,
																		   cups AS C
																	 WHERE C.cup_id = G.cup_id AND
																		   FIELD.game_id = G.game_id AND
																		   FIELD.player_id = "' + @player + '" ' + @sql_year +
																 'GROUP BY C.year,
																		   UPPER(FIELD.POS)
																  ORDER BY FIELD.POS, C.year')
				@playerFieldingByYear = Fielding.find_by_sql('SELECT C.year AS year,
																     COUNT(*) AS G,
																     SUM(FIELD.Innouts/3.0) AS INN,
																     SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																     SUM(FIELD.PO) AS PO,
																     SUM(FIELD.A) AS A,
																     SUM(FIELD.E) AS E,
																     CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT,
																     (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*5 AS Factor5,
																     (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*7 AS Factor7
																FROM fieldings AS FIELD,
																	 games AS G,
																	 cups AS C,
																	 positions
															   WHERE C.cup_id = G.cup_id AND
																	 FIELD.game_id = G.game_id AND
																	 positions.POS = FIELD.POS AND
																	 FIELD.player_id = "' + @player + '" ' + @sql_year +
														   'GROUP BY C.year')
				@playerFieldingByPOS = Fielding.find_by_sql('SELECT FIELD.POS AS POS,
																	COUNT(*) AS G,
																    SUM(FIELD.Innouts/3.0) AS INN,
																    SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																    SUM(FIELD.PO) AS PO,
																    SUM(FIELD.A) AS A,
																    SUM(FIELD.E) AS E,
																    CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT,
																    (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*5 AS Factor5,
																    (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*7 AS Factor7
															   FROM fieldings AS FIELD,
																	games AS G,
																	cups AS C
															  WHERE C.cup_id = G.cup_id AND
																	FIELD.game_id = G.game_id AND
																	FIELD.player_id = "' + @player + '" ' + @sql_year +
														  'GROUP BY UPPER(FIELD.POS)
														   ORDER BY COUNT(*) DESC')
				@playerFieldingByYearAndIO = Fielding.find_by_sql('SELECT C.year AS year,
																		  positions.field,
																		  COUNT(*) AS G,
																		  SUM(FIELD.Innouts/3.0) AS INN,
																		  SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																		  SUM(FIELD.PO) AS PO,
																		  SUM(FIELD.A) AS A,
																		  SUM(FIELD.E) AS E,
																		  CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT,
																		  (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*5 AS Factor5,
																		  (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*7 AS Factor7
																	 FROM fieldings AS FIELD,
																		  games AS G,
																		  cups AS C,
																		  positions
																	WHERE C.cup_id = G.cup_id AND
																		  FIELD.game_id = G.game_id AND
																		  positions.POS = FIELD.POS AND
																		  FIELD.player_id = "' + @player + '" ' + @sql_year +
																'GROUP BY C.year,
																		  positions.field')
			elsif @year != 'Wildcard' && @player != 'all'
				@playerFielding = Fielding.find_by_sql('SELECT FIELD.POS,
															   COUNT(FIELD.game_id) AS G,
															   SUM(FIELD.Innouts/3.0) AS INN,
															   SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
															   SUM(FIELD.PO) AS PO,
															   SUM(FIELD.A) AS A,
															   SUM(FIELD.E) AS E,
															   CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
														  FROM fieldings AS FIELD
														 WHERE FIELD.player_id = "' + @player + '" ' + @sql_year +
													 'GROUP BY FIELD.POS 
													  ORDER BY SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC,
															   SUM(FIELD.Innouts/3.0) DESC,
															   COUNT(FIELD.game_id) DESC')
				@playerFieldingGrass = Fielding.find_by_sql('SELECT COUNT(FIELD.game_id) AS G,
																	SUM(FIELD.Innouts/3.0) AS INN,
																	SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																	SUM(FIELD.PO) AS PO,
																	SUM(FIELD.A) AS A,
																	SUM(FIELD.E) AS E,
																	CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
															   FROM fieldings AS FIELD,
																	positions AS PO,
																	games AS G
															  WHERE G.game_id = FIELD.game_id AND
																	PO.pos = FIELD.POS AND
																	FIELD.player_id = "' + @player + '" AND
																	G.grassfield = 1 AND
																	FIELD.POS IN (SELECT POS 
																					FROM positions
																				   WHERE field = "IF") ' + @sql_year + 
																			   'ORDER BY SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC')[0]
				if @playerFieldingGrass.G == 0
					Struct.new("PlayerFielding", :G, :INN, :TC, :PO, :A, :E, :FPCT)
					@playerFieldingGrass = Struct::PlayerFielding.new(0,0,0,0,0,0,0)
				end
				
				@playerFieldingClay = Fielding.find_by_sql('SELECT COUNT(FIELD.game_id) AS G,
																   SUM(FIELD.Innouts/3.0) AS INN,
																   SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																   SUM(FIELD.PO) AS PO,
																   SUM(FIELD.A) AS A,
																   SUM(FIELD.E) AS E,
																   CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
															  FROM fieldings AS FIELD,
																   positions AS PO,
																   games AS G
															 WHERE G.game_id = FIELD.game_id AND
																   PO.pos = FIELD.POS AND
																   FIELD.player_id = "' + @player + '" AND
																   G.grassfield = 0 AND
																   FIELD.POS IN (SELECT POS 
																				   FROM positions
																				  WHERE field = "IF") ' + @sql_year + 
																			  'ORDER BY SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC')[0]
				if @playerFieldingClay.G == 0
					Struct.new("PlayerFielding", :G, :INN, :TC, :PO, :A, :E, :FPCT)
					@playerFieldingClay = Struct::PlayerFielding.new(0,0,0,0,0,0,0)
				end
				
				@playerFieldingIn = Fielding.find_by_sql('SELECT COUNT(FIELD.game_id) AS G,
																 SUM(FIELD.Innouts/3.0) AS INN,
																 SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																 SUM(FIELD.PO) AS PO,
																 SUM(FIELD.A) AS A,
																 SUM(FIELD.E) AS E,
																 CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
															FROM fieldings AS FIELD,
																 positions AS PO
														   WHERE PO.pos = FIELD.POS AND
																 FIELD.player_id = "' + @player + '" AND
																 FIELD.POS IN (SELECT POS
																				 FROM positions
																				WHERE field = "IF") ' + @sql_year +
																			'ORDER BY SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC')[0]
				if @playerFieldingIn.G == 0
					Struct.new("PlayerFielding", :G, :INN, :TC, :PO, :A, :E, :FPCT)
					@playerFieldingIn = Struct::PlayerFielding.new(0,0,0,0,0,0,0)
				end
				
				@playerFieldingOut = Fielding.find_by_sql('SELECT COUNT(FIELD.game_id) AS G,
																  SUM(FIELD.Innouts/3.0) AS INN,
																  SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																  SUM(FIELD.PO) AS PO,
																  SUM(FIELD.A) AS A,
																  SUM(FIELD.E) AS E,
																  CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
															 FROM fieldings AS FIELD,
																  positions AS PO
															WHERE PO.pos = FIELD.POS AND
																  FIELD.player_id = "' + @player + '" AND
																  FIELD.POS IN (SELECT POS
																				  FROM positions
																				 WHERE field = "OF") ' + @sql_year +
																			 'ORDER BY SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC')[0]
				if @playerFieldingOut.G == 0
					Struct.new("PlayerFielding", :G, :INN, :TC, :PO, :A, :E, :FPCT)
					@playerFieldingOut = Struct::PlayerFielding.new(0,0,0,0,0,0,0)
				end
				
				@playerFieldingTotal = Fielding.find_by_sql('SELECT COUNT(FIELD.game_id) AS G,
																	SUM(FIELD.Innouts/3.0) AS INN,
																	SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																	SUM(FIELD.PO) AS PO,
																	SUM(FIELD.A) AS A,
																	SUM(FIELD.E) AS E,
																	CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
															   FROM fieldings AS FIELD,
																	positions AS PO
															  WHERE PO.pos = FIELD.POS AND
																	FIELD.player_id = "' + @player + '" ' + @sql_year)[0]
				
				@playerFieldingDetail = Fielding.find_by_sql('SELECT FIELD.game_id,
																	 FIELD.POS,
																	 (FIELD.Innouts/3.0) AS INN,
																	 FIELD.PO+FIELD.A+FIELD.E AS TC,
																	 FIELD.PO AS PO,
																	 FIELD.A AS A,
																	 FIELD.E AS E,
																	 CAST(CAST((FIELD.PO+FIELD.A)/(FIELD.PO+FIELD.A+FIELD.E+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
																FROM fieldings AS FIELD
															   WHERE FIELD.player_id = "' + @player + '" ' + @sql_year +
														   'ORDER BY FIELD.game_id')
			end
			
			
			
			
		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	
	end
	
	def king
		
		if logged_in?
		
			@activePLAYER = 150
			@topNumber = 7
			@year = params[:year]
			
			# 每年有幾場比賽
			@gameNumberInEachYear = Cup.find_by_sql('SELECT cups.year,
															COUNT(*) AS gameNumber
													   FROM games,
															cups
													  WHERE games.cup_id = cups.cup_id
												   GROUP BY cups.year')
			@gameNumberInYear = Hash.new(0)
			@gameNumberInWildcard = 0
			@gameNumberInEachYear.each do |gNIEY|
				@gameNumberInYear[gNIEY.year.to_s] = gNIEY.gameNumber
				@gameNumberInWildcard += gNIEY.gameNumber
			end
			@gameNumberInYear['Wildcard'] = @gameNumberInWildcard
			
			if @year == nil
			
				@year_option = Array.new
				@allyear = Cup.select('DISTINCT cups.year').order('cups.year')
				@allyear.each do |eachyear|
					@year_option.push([eachyear.year.to_s + "(" + (eachyear.year - 1911).to_s + "年度)",eachyear.year])
				end
				@year_option.push(["不分年度","Wildcard"])
			
			else
				
				if @year != 'Wildcard'
					@sql_year = ' AND  C.year = ' + @year.to_s + ' '
				else
					@sql_year = ' '
				end
				
				@pit_year = ' AND PIT.game_id IN (SELECT G.game_id 
												    FROM pitchings AS PIT,
														 games AS G,
														 cups AS C 
												   WHERE PIT.game_id = G.game_id AND
														 G.cup_id = C.cup_id ' + @sql_year + ' ) '
				@bat_year = ' AND BAT.game_id IN (SELECT G.game_id
													FROM battings AS BAT,
														 games AS G,
														 cups AS C
												   WHERE BAT.game_id = G.game_id AND
														 G.cup_id = C.cup_id ' + @sql_year + ' ) '
				@game_year = ' AND G.game_id IN (SELECT G.game_id 
												   FROM games AS G,
														cups AS C
												  WHERE G.cup_id = C.cup_id ' + @sql_year + ' ) '
				
				@king_avg = Batting.find_by_sql('SELECT BAT.player_id,
														MBR.name,
														CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
														SUM(BAT.AB) AS AB,
														SUM(BAT.H) AS H
												   FROM battings AS BAT,
														players AS PLY,
														members AS MBR
												  WHERE BAT.player_id = PLY.player_id AND
														PLY.player_id = MBR.id AND
														PLY.member = 1 ' + @bat_year + 
											  'GROUP BY BAT.player_id 
												 HAVING ( SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) >= ' + @gameNumberInYear[@year.to_s].to_s + ' OR
														  SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) >= ' + @activePLAYER.to_s + ' )
											   ORDER BY SUM(BAT.H)/SUM(BAT.AB+0.00000000000000000000000000000000001) DESC,
														SUM(BAT.H) DESC,
														SUM(BAT.RBI) DESC
												  LIMIT ' + @topNumber.to_s)
				@king_avgs = Batting.find_by_sql('SELECT BAT.player_id,
														 MBR.name,
														 SUM(BAT.AB) AS AB,
														 SUM(BAT.H) AS H,
														 SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
														 SUM(BAT.RBI) AS RBI
													FROM battings AS BAT,
														 players AS PLY,
														 members AS MBR
												   WHERE BAT.player_id = PLY.player_id AND
														 PLY.player_id = MBR.id AND
														 PLY.member = 1 ' + @bat_year +
											   'GROUP BY BAT.player_id')
				@avgs_order = 0;
				Struct.new("KingAVGS", :player_id, :name, :AVGS, :AVG, :H, :AB, :PA, :RBI)
				@Array_king_avgs = Array.new
				@king_avgs.each do |k_avgs|
					@PA_diff = [@gameNumberInYear[@year.to_s],@activePLAYER].min - k_avgs.PA
					if @PA_diff <= 0
						@king_avgs_oneplayer = Struct::KingAVGS.new(k_avgs.player_id,k_avgs.name,k_avgs.H / k_avgs.AB.to_f,k_avgs.H / k_avgs.AB.to_f,k_avgs.H,k_avgs.AB,k_avgs.PA,k_avgs.RBI)
					else
						@king_avgs_oneplayer = Struct::KingAVGS.new(k_avgs.player_id,k_avgs.name,k_avgs.H / (k_avgs.AB + @PA_diff).to_f,k_avgs.H / k_avgs.AB.to_f,k_avgs.H,k_avgs.AB,k_avgs.PA,k_avgs.RBI)
					end
					@Array_king_avgs.push(@king_avgs_oneplayer)
				end
				
				@Array_king_avgs.sort! {|a,b| [b.AVGS,b.H,b.RBI] <=> [a.AVGS,a.H,a.RBI] }
				
				@king_h = Batting.find_by_sql('SELECT BAT.player_id,
													  MBR.name,
													  SUM(BAT.H) AS H,
													  SUM(BAT.AB) AS AB
												 FROM battings AS BAT,
													  players AS PLY,
													  members AS MBR
												WHERE BAT.player_id = PLY.player_id AND
													  PLY.player_id = MBR.id AND
													  PLY.member = 1 ' + @bat_year + 
											'GROUP BY BAT.player_id
											   HAVING SUM(BAT.H) > 0
											 ORDER BY SUM(BAT.H) DESC,
													  SUM(BAT.AB)
											    LIMIT ' + @topNumber.to_s)
				@king_hr = Batting.find_by_sql('SELECT BAT.player_id,
													   MBR.name,
													   SUM(BAT.HR) AS HR,
													   SUM(BAT.AB) AS AB
												  FROM battings AS BAT,
													   players AS PLY,
													   members AS MBR
												 WHERE BAT.player_id = PLY.player_id AND
													   PLY.player_id = MBR.id AND
													   PLY.member = 1 ' + @bat_year + 
											 'GROUP BY BAT.player_id
											    HAVING SUM(BAT.HR) > 0
											  ORDER BY SUM(BAT.HR) DESC,
													   SUM(BAT.AB),
													   SUM(BAT.RBI) DESC
											     LIMIT ' + @topNumber.to_s)
				@king_rbi = Batting.find_by_sql('SELECT BAT.player_id,
													    MBR.name,
													    SUM(BAT.RBI) AS RBI,
													    SUM(BAT.AB) AS AB
												   FROM battings AS BAT,
													    players AS PLY,
													    members AS MBR
												  WHERE BAT.player_id = PLY.player_id AND
													    PLY.player_id = MBR.id AND
													    PLY.member = 1 ' + @bat_year + 
											  'GROUP BY BAT.player_id
											   ORDER BY SUM(BAT.RBI) DESC,
													    SUM(BAT.H)/SUM(BAT.AB+0.00000000000000000000000000000000001) DESC,
													    SUM(BAT.AB) DESC
											      LIMIT ' + @topNumber.to_s)
				@king_r = Batting.find_by_sql('SELECT BAT.player_id,
													  MBR.name,
													  SUM(BAT.R) AS R
												 FROM battings AS BAT,
													  players AS PLY,
													  members AS MBR
												WHERE BAT.player_id = PLY.player_id AND
													  PLY.player_id = MBR.id AND
													  PLY.member = 1 ' + @bat_year + 
											'GROUP BY BAT.player_id
											 ORDER BY SUM(BAT.R) DESC,
													  SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)
											    LIMIT ' + @topNumber.to_s)
				@king_era = Pitching.find_by_sql('SELECT PIT.player_id,
														 MBR.name,
														 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
														 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
														 SUM(PIT.ER) AS ER,
														 SUM(PIT.IPouts)/3.0 AS IP
													FROM pitchings AS PIT,
														 players AS PLY,
														 members AS MBR
												   WHERE PLY.player_id = PIT.player_id AND
														 PLY.player_id = MBR.id AND
														 PLY.member = 1 ' + @pit_year + 
											   'GROUP BY PIT.player_id
												  HAVING ( SUM(PIT.IPouts)/3.0 >= ' + @gameNumberInYear[@year.to_s].to_s + ' OR
														   SUM(PIT.IPouts)/3.0 >= ' + @activePLAYER.to_s + ' )
												ORDER BY SUM(PIT.ER)/SUM(PIT.IPouts+0.0000000000000000000000000000000000000001)
												   LIMIT ' + @topNumber.to_s)
				@king_w = Pitching.find_by_sql('SELECT PIT.player_id,
													   MBR.name,
													   SUM(PIT.W) AS W,
													   COUNT(*) AS G
												  FROM pitchings AS PIT,
													   players AS PLY,
													   members AS MBR
												 WHERE PLY.player_id = PIT.player_id AND
													   PLY.player_id = MBR.id AND
													   PLY.member = 1 ' + @pit_year + 
											 'GROUP BY PIT.player_id
												HAVING SUM(PIT.W) > 0
											  ORDER BY SUM(PIT.W) DESC,
													   SUM(PIT.W)/(SUM(PIT.W)+SUM(PIT.L)) DESC
												 LIMIT ' + @topNumber.to_s)
				@king_so = Pitching.find_by_sql('SELECT PIT.player_id,
													   MBR.name,
													   SUM(PIT.SO) AS SO,
													   SUM(PIT.IPouts)/3.0 AS IP
												  FROM pitchings AS PIT,
													   players AS PLY,
													   members AS MBR
												 WHERE PLY.player_id = PIT.player_id AND
													   PLY.player_id = MBR.id AND
													   PLY.member = 1 ' + @pit_year + 
											 'GROUP BY PIT.player_id
												HAVING SUM(PIT.SO) > 0
											  ORDER BY SUM(PIT.SO) DESC,
													   SUM(PIT.IPouts)/3.0
												 LIMIT ' + @topNumber.to_s)
				@king_2b = Batting.find_by_sql('SELECT BAT.player_id,
													   MBR.name,
													   SUM(BAT.B2) AS B2,
													   SUM(BAT.AB) AS AB
												  FROM battings AS BAT,
													   players AS PLY,
													   members AS MBR
												 WHERE BAT.player_id = PLY.player_id AND
													   PLY.player_id = MBR.id AND
													   PLY.member = 1 ' + @bat_year + 
											 'GROUP BY BAT.player_id
												HAVING SUM(BAT.B2) > 0
											  ORDER BY SUM(BAT.B2) DESC,
													   SUM(BAT.AB)
											     LIMIT ' + @topNumber.to_s)
				@king_3b = Batting.find_by_sql('SELECT BAT.player_id,
													   MBR.name,
													   SUM(BAT.B3) AS B3,
													   SUM(BAT.AB) AS AB
												  FROM battings AS BAT,
													   players AS PLY,
													   members AS MBR
												 WHERE BAT.player_id = PLY.player_id AND
													   PLY.player_id = MBR.id AND
													   PLY.member = 1 ' + @bat_year + 
											 'GROUP BY BAT.player_id
												HAVING SUM(BAT.B3) > 0
											  ORDER BY SUM(BAT.B3) DESC,
													   SUM(BAT.AB)
											     LIMIT ' + @topNumber.to_s)
				@king_mvp = Game.find_by_sql('SELECT G.mvp AS player_id,
													 MBR.name,
													 COUNT(G.mvp) AS MVP
												FROM games AS G,
													 players AS PLY,
													 members AS MBR
											   WHERE G.mvp = PLY.player_id AND
													 PLY.player_id = MBR.id AND
													 PLY.member = 1 ' + @game_year +
										   'GROUP BY G.mvp
										    ORDER BY COUNT(G.mvp) DESC
											   LIMIT ' + @topNumber.to_s)
				@king_whip = Pitching.find_by_sql('SELECT PIT.player_id,
														  MBR.name,
														  (SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
														  SUM(PIT.H) AS H,
														  SUM(PIT.BB) AS BB,
														  SUM(PIT.IBB) AS IBB,
														  SUM(PIT.IPouts)/3.0 AS IP
													 FROM pitchings AS PIT,
														  players AS PLY,
														  members AS MBR
													WHERE PLY.player_id = PIT.player_id AND
														  PLY.player_id = MBR.id AND
														  PLY.member = 1 ' + @pit_year + 
												'GROUP BY PIT.player_id
												   HAVING ( SUM(PIT.IPouts)/3.0 >= ' + @gameNumberInYear[@year.to_s].to_s + ' OR
														    SUM(PIT.IPouts)/3.0 >= ' + @activePLAYER.to_s + ' )
												 ORDER BY (SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3
													LIMIT ' + @topNumber.to_s)
				@king_tb = Batting.find_by_sql('SELECT BAT.player_id,
													   MBR.name,
													   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
													   SUM(BAT.AB) AS AB
												  FROM battings AS BAT,
													   players AS PLY,
													   members AS MBR
												 WHERE BAT.player_id = PLY.player_id AND
													   PLY.player_id = MBR.id AND
													   PLY.member = 1 ' + @bat_year + 
											 'GROUP BY BAT.player_id
												HAVING SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 > 0
											  ORDER BY SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 DESC,
													   SUM(BAT.AB)
											     LIMIT ' + @topNumber.to_s)
				@king_silver = Batting.find_by_sql('SELECT BAT.player_id,
														   MBR.name,
													       (CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0)*1000+SUM(BAT.HR)*20+SUM(BAT.RBI)*5+(SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3) AS SILVER
													  FROM battings AS BAT,
														   players AS PLY,
														   members AS MBR
													 WHERE BAT.player_id = PLY.player_id AND
														   PLY.player_id = MBR.id AND
														   PLY.member = 1 ' + @bat_year + 
												 'GROUP BY BAT.player_id
												  ORDER BY (CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0)*1000+SUM(BAT.HR)*20+SUM(BAT.RBI)*5+(SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3) DESC
													 LIMIT ' + @topNumber.to_s)
			end
			
		
		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	
	end
	
	def team
		
		if logged_in?
			
			@team = params[:team]
			@activePLAYER_Batting = 1
			@activePLAYER_Fielding = 1.5
			
			if @team == nil
				
				@team_option = Array.new
				@allteam = Team.find_by_sql('SELECT T.team_id,
													T.team_name,
													COUNT(T.team_id) AS NUM
											   FROM teams AS T,
													games AS G
											  WHERE (T.team_id = G.home_team_id OR
													T.team_id = G.away_team_id) AND
													T.team_id NOT IN (SELECT team_id
																		FROM teams 
																	   WHERE team_id LIKE "IM%")
										   GROUP BY T.team_id,
													T.team_name
										   ORDER BY T.team_name')
				@allteam.each do |eachteam|
					@team_option.push([eachteam.team_name + " (" + eachteam.NUM.to_s + "場)",eachteam.team_id])
				end
				
			else
			
				@team_info = Team.find_by_sql('SELECT COUNT(*) AS gameNum,
													  T.team_name
												 FROM games AS G,
													  teams AS T 
												WHERE (G.home_team_id = "' + @team + '" AND T.team_id = G.home_team_id) OR
													  (G.away_team_id = "' + @team + '" AND T.team_id = G.away_team_id)
											 GROUP BY T.team_name')[0]
				@team_gamelist = Game.find_by_sql('SELECT G.game_id,
														  C.year,
														  C.cup_name,
														  teamAway.team_name AS teamAwayName,
														  G.away_score,
														  G.home_score,
														  teamHome.team_name AS teamHomeName,
														  G.time,
														  G.mvp
													 FROM games AS G,
														  cups AS C,
														  teams AS teamHome,
														  teams AS teamAway
													WHERE G.cup_id = C.cup_id AND
														  teamHome.team_id = G.home_team_id AND
														  teamAway.team_id = G.away_team_id AND
														  (G.home_team_id = "' + @team + '" or G.away_team_id = "' + @team + '")
												 ORDER BY G.game_id')
				@team_batting = Batting.find_by_sql('SELECT BAT.player_id,
															COUNT(*) AS G,
															SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
															SUM(BAT.AB) AS AB,
															SUM(BAT.H) AS H,
															SUM(BAT.B2) AS B2,
															SUM(BAT.B3) AS B3,
															SUM(BAT.HR) AS HR,
															SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
															SUM(BAT.RBI) AS RBI,
															SUM(BAT.R) AS R,
															SUM(BAT.SO) AS SO,
															SUM(BAT.BB) AS BB,
															SUM(BAT.IBB) AS IBB,
															SUM(BAT.SF) AS SF,
															SUM(BAT.E) AS E,
															CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
															CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
															CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
															(CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
															CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA
													   FROM battings AS BAT,
															players AS PLY
													  WHERE BAT.player_id = PLY.player_id AND
															PLY.active = 1 AND
															BAT.game_id IN (SELECT G.game_id
																			  FROM games AS G
																			 WHERE G.home_team_id = "' + @team + '" OR
																				   G.away_team_id = "' + @team + '" )
																		  GROUP BY BAT.player_id
																		  ORDER BY (SUM(BAT.H)/(SUM(BAT.AB)+0.00000000000000000000000000000000000001)) DESC,
																				   ((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.00000000000000001)) DESC')
				@team_batting_summary = Batting.find_by_sql('SELECT SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																	SUM(BAT.AB) AS AB,
																	SUM(BAT.H) AS H,
																	SUM(BAT.B2) AS B2,
																	SUM(BAT.B3) AS B3,
																	SUM(BAT.HR) AS HR,
																	SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																	SUM(BAT.RBI) AS RBI,
																	SUM(BAT.R) AS R,
																	SUM(BAT.SO) AS SO,
																	SUM(BAT.BB) AS BB,
																	SUM(BAT.IBB) AS IBB,
																	SUM(BAT.SF) AS SF,
																	SUM(BAT.E) AS E,
																	CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																	CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
																	CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
																	(CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
																	CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA
															   FROM battings AS BAT,
																	players AS PLY
															  WHERE BAT.player_id = PLY.player_id AND
																	PLY.active = 1 AND
																	BAT.game_id IN (SELECT G.game_id
																					  FROM games AS G
																					 WHERE G.home_team_id = "' + @team + '" OR
																						   G.away_team_id = "' + @team + '" )')[0]
				@team_pitching = Pitching.find_by_sql('SELECT PIT.player_id,
															  COUNT(PIT.game_id) AS G,
															  SUM(PIT.W) AS W,
															  SUM(PIT.L) AS L,
															  SUM(PIT.IPouts/3.0) AS IP,
															  SUM(PIT.BAOpp) AS TBF,
															  SUM(PIT.H) AS H,
															  SUM(PIT.HR) AS HR,
															  SUM(PIT.SO) AS SO,
															  SUM(PIT.BB) AS BB,
															  SUM(PIT.IBB) AS IBB,
															  SUM(PIT.R) AS R,
															  SUM(PIT.ER) AS ER,
															  CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
														      (SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
														      CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
														      CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
														      CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R5,
														      CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R7
														 FROM pitchings AS PIT,
															  players AS PLY
														WHERE PLY.player_id = PIT.player_id AND
															  PLY.active = 1 AND
															  PIT.game_id IN (SELECT G.game_id
																				FROM games AS G
																			   WHERE G.home_team_id = "' + @team + '" OR
																					 G.away_team_id = "' + @team + '" )
																			GROUP BY PIT.player_id
																			ORDER BY SUM(PIT.ER)/SUM(PIT.IPouts+0.0000000000000000000000000000000000000001)')
				@team_pitching_summary = Pitching.find_by_sql('SELECT SUM(PIT.W) AS W,
																	  SUM(PIT.L) AS L,
																	  SUM(PIT.IPouts/3.0) AS IP,
																	  SUM(PIT.BAOpp) AS TBF,
																	  SUM(PIT.H) AS H,
																	  SUM(PIT.HR) AS HR,
																	  SUM(PIT.SO) AS SO,
																	  SUM(PIT.BB) AS BB,
																	  SUM(PIT.IBB) AS IBB,
																	  SUM(PIT.R) AS R,
																	  SUM(PIT.ER) AS ER,
																	  CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																	  (SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
																	  CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
																	  CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
																	  CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R5,
																	  CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R7
																 FROM pitchings AS PIT,
																	  players AS PLY
																WHERE PLY.player_id = PIT.player_id AND
																	  PLY.active = 1 AND
																	  PIT.game_id IN (SELECT G.game_id
																						FROM games AS G
																					   WHERE G.home_team_id = "' + @team + '" OR
																							 G.away_team_id = "' + @team + '" )')[0]
				@team_fielding = Fielding.find_by_sql('SELECT FIELD.player_id,
															  COUNT(FIELD.game_id) AS G,
															  SUM(FIELD.Innouts/3.0) AS INN,
															  SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
															  SUM(FIELD.PO) AS PO,
															  SUM(FIELD.A) AS A,
															  SUM(FIELD.E) AS E,
															  CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT,
															  (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*5 AS Factor5,
															  (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*7 AS Factor7
														 FROM fieldings AS FIELD,
															  players AS PLY
														WHERE FIELD.player_id = PLY.player_id AND
															  PLY.active = 1 AND
															  FIELD.game_id IN ( SELECT G.game_id
																				   FROM games AS G
																				  WHERE G.home_team_id = "' + @team + '" OR
																						G.away_team_id = "' + @team + '" )
																			   GROUP BY FIELD.player_id
																			   ORDER BY CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 DESC,
																						SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC')
				@team_fielding_summary = Fielding.find_by_sql('SELECT FIELD.player_id,
																	  COUNT(FIELD.game_id) AS G,
																	  SUM(FIELD.Innouts/3.0) AS INN,
																	  SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																	  SUM(FIELD.PO) AS PO,
																	  SUM(FIELD.A) AS A,
																	  SUM(FIELD.E) AS E,
																	  CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT,
																	  (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*5 AS Factor5,
																	  (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*7 AS Factor7
																 FROM fieldings AS FIELD,
																	  players AS PLY
																WHERE FIELD.player_id = PLY.player_id AND
																	  PLY.active = 1 AND
																	  FIELD.game_id IN ( SELECT G.game_id
																						   FROM games AS G
																						  WHERE G.home_team_id = "' + @team + '" OR
																								G.away_team_id = "' + @team + '" )')[0]
			end
			
		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
	def cup
		
		if logged_in?
		
			@year = params[:year]
			@activePLAYER_Batting = 1
			@activePLAYER_Fielding = 1.5
			
			if @year == 'Wildcard' 
				@Cyear = ' '
			else
				@Cyear = ' AND C.year = ' + @year.to_s + ' '
			end
			@cup = params[:cup]
			
			if @year== nil || @cup == nil
				
				@year_option = Array.new
				@allCupName = Cup.select('DISTINCT cups.cup_name')
				@allCupName.each do |eachName|
					@year_option.push(['不分年度-' + eachName.cup_name,'Wildcard'])
				end
				@year_option.push(['不分年度-正式賽','Wildcard'])
				@year_option.push(['不分年度-官方賽','Wildcard'])
				
				@allyear = Cup.select('DISTINCT cups.year').order('cups.year DESC')
				@allyear.each do |eachyear|
					@year_option.push([eachyear.year.to_s + '年度-正式賽',eachyear.year])
				end
				@allyear.each do |eachyear|
					@year_option.push([eachyear.year.to_s + '年度-官方賽',eachyear.year])
				end
				@allCupYearName = Cup.select('DISTINCT cups.year, cups.cup_name').order('cups.year DESC')
				@allCupYearName.each do |eachyearname|
					@year_option.push([eachyearname.year.to_s + '年度-' + eachyearname.cup_name,eachyearname.year])
				end
				
				@allOfficial = Cup.select('DISTINCT cups.cup_name').where('cups.official = 1').order('cups.cup_name')
				@allFormal = Cup.select('DISTINCT cups.cup_name').where('cups.formal = 1').order('cups.cup_name')
				@listOfficial = ''
				@listFormal = ''
				@allOfficial.each_with_index do |eachOfficial, index|
					@listOfficial += eachOfficial.cup_name
					if index == @allOfficial.length() - 1
						@listOfficial += '。'
					else
						@listOfficial += ' '
					end
				end
				@allFormal.each_with_index do |eachFormal, index|
					@listFormal += eachFormal.cup_name
					if index == @allFormal.length() - 1
						@listFormal += '。'
					else
						@listFormal += ' '
					end
				end
			
			else
				
				if @cup == '正式賽'
					@gameNumber = 'SELECT COUNT(*) AS NUM
									 FROM games AS G, 
										  cups AS C
									WHERE G.cup_id = C.cup_id AND
										  C.formal = 1 ' + @Cyear
					@cup_name = ' C.formal = 1 '
				elsif @cup == '官方賽'
					@gameNumber = 'SELECT COUNT(*) AS NUM
									 FROM games AS G, 
										  cups AS C
									WHERE G.cup_id = C.cup_id AND
										  C.official = 1 ' + @Cyear
					@cup_name = ' C.official = 1 ';	
				else
					@gameNumber = 'SELECT COUNT(*) AS NUM
									 FROM games AS G,
										  cups AS C
									WHERE G.cup_id = C.cup_id AND
										  C.cup_name = "' + @cup + '" ' + @Cyear
					@cup_name = ' C.cup_name = "' + @cup + '" '
				end
				
				# for 新生盃
				if @cup == '新生盃'
					@active = ' '
				else
					@active = ' AND PLY.member = 1 '
				end
				
				@num_of_game = Game.find_by_sql(@gameNumber)[0].NUM
			
				@cup_gamelist = Game.find_by_sql('SELECT G.game_id,
														 year,
														 cup_name,
														 teamAway.team_name AS teamAwayName,
														 G.away_score,
														 G.home_score,
														 teamHome.team_name AS teamHomeName,
														 G.time,
														 G.mvp
													FROM games AS G,
														 cups AS C,
														 teams AS teamHome,
														 teams AS teamAway
												   WHERE G.cup_id = C.cup_id AND
														 teamHome.team_id = G.home_team_id AND
														 teamAway.team_id = G.away_team_id AND ' +
														 @cup_name + 
														 @Cyear +
											  ' ORDER BY G.game_id')
				@cup_batting = Batting.find_by_sql('SELECT BAT.player_id,
														   COUNT(*) AS G,
														   SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
														   SUM(BAT.AB) AS AB,
														   SUM(BAT.H) AS H,
															SUM(BAT.B2) AS B2,
															SUM(BAT.B3) AS B3,
															SUM(BAT.HR) AS HR,
															SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
															SUM(BAT.RBI) AS RBI,
															SUM(BAT.R) AS R,
															SUM(BAT.SO) AS SO,
															SUM(BAT.BB) AS BB,
															SUM(BAT.IBB) AS IBB,
															SUM(BAT.SF) AS SF,
															SUM(BAT.E) AS E,
															CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
															CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
															CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
															(CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
															CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA 
													   FROM battings AS BAT,
															players AS PLY
													  WHERE BAT.player_id = PLY.player_id ' + @active + ' AND
															BAT.game_id IN (SELECT G.game_id
																			  FROM games AS G,
																				   cups AS C
																			 WHERE G.cup_id = C.cup_id AND ' +
																				   @cup_name +
																				   @Cyear + ' )
																		  GROUP BY BAT.player_id
																		  ORDER BY (SUM(BAT.H)/(SUM(BAT.AB)+0.00000000000000000000000000000000000001)) DESC,
																				   ((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.00000000000000001)) DESC,
																				   (SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.000000000000000001) DESC')
				@cup_batting_summary = Batting.find_by_sql('SELECT SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																   SUM(BAT.AB) AS AB,
																   SUM(BAT.H) AS H,
																   SUM(BAT.B2) AS B2,
																   SUM(BAT.B3) AS B3,
																   SUM(BAT.HR) AS HR,
																   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																   SUM(BAT.RBI) AS RBI,
																   SUM(BAT.R) AS R,
																   SUM(BAT.SO) AS SO,
																   SUM(BAT.BB) AS BB,
																   SUM(BAT.IBB) AS IBB,
																   SUM(BAT.SF) AS SF,
																   SUM(BAT.E) AS E,
																   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																   CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
																   CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
																   (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
																   CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA 
															  FROM battings AS BAT,
																   players AS PLY
															 WHERE BAT.player_id = PLY.player_id ' + @active + ' AND
																   BAT.game_id IN (SELECT G.game_id
																					  FROM games AS G,
																						   cups AS C
																					 WHERE G.cup_id = C.cup_id AND ' +
																						   @cup_name +
																						   @Cyear + ' )')[0]
				@cup_pitching = Pitching.find_by_sql('SELECT PIT.player_id,
															  COUNT(PIT.game_id) AS G,
															  SUM(PIT.W) AS W,
															  SUM(PIT.L) AS L,
															  SUM(PIT.IPouts/3.0) AS IP,
															  SUM(PIT.BAOpp) AS TBF,
															  SUM(PIT.H) AS H,
															  SUM(PIT.HR) AS HR,
															  SUM(PIT.SO) AS SO,
															  SUM(PIT.BB) AS BB,
															  SUM(PIT.IBB) AS IBB,
															  SUM(PIT.R) AS R,
															  SUM(PIT.ER) AS ER,
															  CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
														      (SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
														      CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
														      CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
														      CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R5,
														      CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R7
														 FROM pitchings AS PIT,
															  players AS PLY
														WHERE PLY.player_id = PIT.player_id ' + @active + ' AND
															  PIT.game_id IN (SELECT game_id
																				FROM games AS G,
																					 cups AS C
																			   WHERE G.cup_id = C.cup_id AND ' +
																					 @cup_name +
																					 @Cyear + ' )
																			GROUP BY PIT.player_id
																			ORDER BY SUM(PIT.ER)/SUM(PIT.IPouts+0.0000000000000000000000000000000000000001)')
				@cup_pitching_summary = Pitching.find_by_sql('SELECT SUM(PIT.W) AS W,
																     SUM(PIT.L) AS L,
																     SUM(PIT.IPouts/3.0) AS IP,
																     SUM(PIT.BAOpp) AS TBF,
																     SUM(PIT.H) AS H,
																     SUM(PIT.HR) AS HR,
																     SUM(PIT.SO) AS SO,
																     SUM(PIT.BB) AS BB,
																     SUM(PIT.IBB) AS IBB,
																     SUM(PIT.R) AS R,
																     SUM(PIT.ER) AS ER,
																     CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																     (SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
																     CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
																     CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
																     CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R5,
																     CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R7
																FROM pitchings AS PIT,
																	 players AS PLY
															   WHERE PLY.player_id = PIT.player_id ' + @active + ' AND
																	 PIT.game_id IN (SELECT game_id
																					   FROM games AS G,
																							cups AS C
																					  WHERE G.cup_id = C.cup_id AND ' +
																							@cup_name +
																							@Cyear + ' )')[0]
				
				if @cup == '系級盃'
					@activePLAYER_Fielding = 1;
				end
				
				@cup_fielding = Fielding.find_by_sql('SELECT FIELD.player_id,
															 COUNT(FIELD.game_id) AS G,
															 SUM(FIELD.Innouts/3.0) AS INN,
															 SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
															 SUM(FIELD.PO) AS PO,
															 SUM(FIELD.A) AS A,
															 SUM(FIELD.E) AS E,
															 CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT,
															 (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*5 AS Factor5,
															 (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*7 AS Factor7
														FROM fieldings AS FIELD,
															 players AS PLY
													   WHERE FIELD.player_id = PLY.player_id ' + @active + ' AND
															 FIELD.game_id IN (SELECT game_id
																				 FROM games AS G,
																					  cups AS C
																				WHERE G.cup_id = C.cup_id AND ' +
																					  @cup_name +
																					  @Cyear + ' )
																			 GROUP BY FIELD.player_id
																			 ORDER BY CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 DESC,
																					  SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC')
				@cup_fielding_summary = Fielding.find_by_sql('SELECT SUM(FIELD.Innouts/3.0) AS INN,
																	 SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																	 SUM(FIELD.PO) AS PO,
																	 SUM(FIELD.A) AS A,
																	 SUM(FIELD.E) AS E,
																	 CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT,
																	 (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*5 AS Factor5,
																	 (SUM(PO)+SUM(A)-SUM(E))/((SUM(FIELD.InnOuts)+0.0000000000000000000000000000001)/3.0)*7 AS Factor7
																FROM fieldings AS FIELD,
																	 players AS PLY
															   WHERE FIELD.player_id = PLY.player_id ' + @active + ' AND
																	 FIELD.game_id IN (SELECT game_id
																						 FROM games AS G,
																							  cups AS C
																						WHERE G.cup_id = C.cup_id AND ' +
																							  @cup_name +
																							  @Cyear + ' )')[0]
			end
		
		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	
	end
	
	def playerBattingClassifiedHelper(type, player_id)
	
		if type == 'formal'
			@select_game_id = ' SELECT G.game_id
								  FROM battings AS BAT,
									   games AS G,
									   cups AS C
								 WHERE BAT.game_id = G.game_id AND
									   G.cup_id = C.cup_id AND
									   C.formal = 1 '
		elsif type == 'official'
			@select_game_id = ' SELECT G.game_id
								  FROM battings AS BAT,
									   games AS G,
									   cups AS C
								 WHERE BAT.game_id = G.game_id AND
									   G.cup_id = C.cup_id AND
									   C.formal = 1 AND
									   C.official = 1 '
		else
			@select_game_id = ' SELECT G.game_id
								  FROM battings AS BAT,
									   games AS G,
									   cups AS C
								 WHERE BAT.game_id = G.game_id AND
									   G.cup_id = C.cup_id AND
									   C.formal = 0 '
		end
	
		@playerBattingClassified = Batting.find_by_sql('SELECT COUNT(BAT.game_id) AS G,
															   SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
															   SUM(BAT.AB) AS AB,
															   SUM(BAT.H) AS H,
															   SUM(BAT.B2) AS B2,
															   SUM(BAT.B3) AS B3,
															   SUM(BAT.HR) AS HR,
															   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
															   SUM(BAT.RBI) AS RBI,
															   SUM(BAT.R) AS R,
															   SUM(BAT.SO) AS SO,
															   SUM(BAT.BB) AS BB,
															   SUM(BAT.IBB) AS IBB,
															   SUM(BAT.SF) AS SF,
															   SUM(BAT.E) AS E,
															   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
															   (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
															   CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA,
															   (CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0)*1000+SUM(BAT.HR)*20+SUM(BAT.RBI)*5+(SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3) AS SILVER
														  FROM battings AS BAT
														 WHERE BAT.game_id IN (' + @select_game_id + ') AND
															   BAT.player_id = "' + player_id + '" ')[0]
		return @playerBattingClassified
	end
	
	def playerPitchingClassifiedHelper(type, player_id)
	
		if type == 'formal'
			@select_game_id = ' SELECT G.game_id
								  FROM pitchings AS PIT,
									   games AS G,
									   cups AS C
								 WHERE PIT.game_id = G.game_id AND
									   G.cup_id = C.cup_id AND
									   C.formal = 1 '
		elsif type == 'official'
			@select_game_id = ' SELECT G.game_id
								  FROM pitchings AS PIT,
									   games AS G,
									   cups AS C
								 WHERE PIT.game_id = G.game_id AND
									   G.cup_id = C.cup_id AND
									   C.official = 1 '
		elsif type == 'friendly'
			@select_game_id = ' SELECT G.game_id
								  FROM pitchings AS PIT,
									   games AS G,
									   cups AS C
								 WHERE PIT.game_id = G.game_id AND
									   G.cup_id = C.cup_id AND
									   C.formal = 0 '
		elsif type == 'starter'
			@select_game_id = ' SELECT G.game_id
								  FROM pitchings AS PIT,
									   games AS G
								 WHERE PIT.game_id = G.game_id AND
									   PIT.player_id = "' + player_id + '" AND
									   PIT.order = 1 '
		elsif type == 'reliever'
			@select_game_id = ' SELECT G.game_id
								  FROM pitchings AS PIT,
									   games AS G
								 WHERE PIT.game_id = G.game_id AND
									   PIT.player_id = "' + player_id + '" AND
									   PIT.order > 1 '
		end
	
		@playerPitchingClassified = Pitching.find_by_sql('SELECT COUNT(PIT.game_id) AS G,
															     SUM(PIT.W) AS W,
															     SUM(PIT.L) AS L,
															     SUM(PIT.IPouts/3.0) AS IP,
															     SUM(PIT.BAOpp) AS TBF,
															     SUM(PIT.H) AS H,
															     SUM(PIT.HR) AS HR,
															     SUM(PIT.SO) AS SO,
															     SUM(PIT.BB) AS BB,
															     SUM(PIT.IBB) AS IBB,
															     SUM(PIT.R) AS R,
															     SUM(PIT.ER) AS ER,
															     CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
															     (SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
															     CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
															     CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
															     CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R5,
															     CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R7
															FROM pitchings AS PIT
														   WHERE PIT.game_id IN (' + @select_game_id + ') AND
																 PIT.player_id = "' + player_id + '" ')[0]
		return @playerPitchingClassified
	end
	
	def player
	
		if logged_in?
		
			@player = params[:player]
			@inactive = params[:inactive]
			
			if @player == nil
				
				@player_option = Array.new
				@allPlayer = Player.select('players.player_id, members.name').where('players.member = 1').joins('INNER JOIN members ON members.id = players.player_id').order('players.player_id')
				@allPlayer.each do |eachPlayer|
					@player_option.push([eachPlayer.name + ' (' + eachPlayer.player_id + ')',eachPlayer.player_id])
				end
				
			else
			
				@playerName = (Member.find_by_id(@player))? Member.find(@player).name : @player
				@playerYearBatting = Batting.find_by_sql('SELECT C.year,
																 COUNT(BAT.game_id) AS G,
																 SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																 SUM(BAT.AB) AS AB,
																 SUM(BAT.H) AS H,
																 SUM(BAT.B2) AS B2,
																 SUM(BAT.B3) AS B3,
																 SUM(BAT.HR) AS HR,
																 SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																 SUM(BAT.RBI) AS RBI,
																 SUM(BAT.R) AS R,
																 SUM(BAT.SO) AS SO,
																 SUM(BAT.BB) AS BB,
																 SUM(BAT.IBB) AS IBB,
																 SUM(BAT.SF) AS SF,
																 SUM(BAT.E) AS E,
																 CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																 CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
																 CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
																 (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
																 CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA,
																 (CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0)*1000+SUM(BAT.HR)*20+SUM(BAT.RBI)*5+(SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3) AS SILVER
															FROM battings AS BAT,
																 games AS G,
																 cups AS C
														   WHERE BAT.game_id = G.game_id AND
																 G.cup_id = C.cup_id AND
																 BAT.player_id = "' + @player + '"
														GROUP BY C.year')
				@playerYearBattingSummary = Batting.find_by_sql('SELECT COUNT(BAT.game_id) AS G,
																		SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																		SUM(BAT.AB) AS AB,
																		SUM(BAT.H) AS H,
																		SUM(BAT.B2) AS B2,
																		SUM(BAT.B3) AS B3,
																		SUM(BAT.HR) AS HR,
																		SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																		SUM(BAT.RBI) AS RBI,
																		SUM(BAT.R) AS R,
																		SUM(BAT.SO) AS SO,
																		SUM(BAT.BB) AS BB,
																		SUM(BAT.IBB) AS IBB,
																		SUM(BAT.SF) AS SF,
																		SUM(BAT.E) AS E,
																		CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																		CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
																		CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
																		(CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
																		CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA,
																		(CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0)*1000+SUM(BAT.HR)*20+SUM(BAT.RBI)*5+(SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3) AS SILVER
																   FROM battings AS BAT,
																		games AS G,
																		cups AS C
																  WHERE BAT.game_id = G.game_id AND
																		G.cup_id = C.cup_id AND
																		BAT.player_id = "' + @player + '"')[0]
				
				@allOfficial = Cup.select('DISTINCT cups.cup_name').where('cups.official = 1').order('cups.cup_name')
				@allFormal = Cup.select('DISTINCT cups.cup_name').where('cups.formal = 1').order('cups.cup_name')
				@listOfficial = ''
				@listFormal = ''
				@allOfficial.each_with_index do |eachOfficial, index|
					@listOfficial += eachOfficial.cup_name
					if index == @allOfficial.length() - 1
						@listOfficial += '。'
					else
						@listOfficial += ' '
					end
				end
				@allFormal.each_with_index do |eachFormal, index|
					@listFormal += eachFormal.cup_name
					if index == @allFormal.length() - 1
						@listFormal += '。'
					else
						@listFormal += ' '
					end
				end
				
				@playerBattingFormal = playerBattingClassifiedHelper('formal',@player)
				@playerBattingOfficial = playerBattingClassifiedHelper('official',@player)
				@playerBattingFriendly = playerBattingClassifiedHelper('friendly',@player)
				
				@playerFielding = Fielding.find_by_sql('SELECT FIELD.POS,
															   COUNT(FIELD.game_id) AS G,
															   SUM(FIELD.Innouts/3.0) AS INN,
															   SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
															   SUM(FIELD.PO) AS PO,
															   SUM(FIELD.A) AS A,
															   SUM(FIELD.E) AS E,
															   CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
														  FROM fieldings AS FIELD
														 WHERE FIELD.player_id = "' + @player + '" 
													  GROUP BY FIELD.POS 
													  ORDER BY SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC,
															   SUM(FIELD.Innouts/3.0) DESC,
															   COUNT(FIELD.game_id) DESC')
				@playerFieldingGrass = Fielding.find_by_sql('SELECT COUNT(FIELD.game_id) AS G,
																	SUM(FIELD.Innouts/3.0) AS INN,
																	SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																	SUM(FIELD.PO) AS PO,
																	SUM(FIELD.A) AS A,
																	SUM(FIELD.E) AS E,
																	CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
															   FROM fieldings AS FIELD,
																	positions AS PO,
																	games AS G
															  WHERE G.game_id = FIELD.game_id AND
																	PO.pos = FIELD.POS AND
																	FIELD.player_id = "' + @player + '" AND
																	G.grassfield = 1 AND
																	FIELD.POS IN (SELECT POS 
																					FROM positions
																				   WHERE field = "IF") 
																			    ORDER BY SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC')[0]
				if @playerFieldingGrass.G == 0
					Struct.new("PlayerFielding", :G, :INN, :TC, :PO, :A, :E, :FPCT)
					@playerFieldingGrass = Struct::PlayerFielding.new(0,0,0,0,0,0,0)
				end
				
				@playerFieldingClay = Fielding.find_by_sql('SELECT COUNT(FIELD.game_id) AS G,
																   SUM(FIELD.Innouts/3.0) AS INN,
																   SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																   SUM(FIELD.PO) AS PO,
																   SUM(FIELD.A) AS A,
																   SUM(FIELD.E) AS E,
																   CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
															  FROM fieldings AS FIELD,
																   positions AS PO,
																   games AS G
															 WHERE G.game_id = FIELD.game_id AND
																   PO.pos = FIELD.POS AND
																   FIELD.player_id = "' + @player + '" AND
																   G.grassfield = 0 AND
																   FIELD.POS IN (SELECT POS 
																				   FROM positions
																				  WHERE field = "IF") 
																			   ORDER BY SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC')[0]
				if @playerFieldingClay.G == 0
					Struct.new("PlayerFielding", :G, :INN, :TC, :PO, :A, :E, :FPCT)
					@playerFieldingClay = Struct::PlayerFielding.new(0,0,0,0,0,0,0)
				end
				
				@playerFieldingIn = Fielding.find_by_sql('SELECT COUNT(FIELD.game_id) AS G,
																 SUM(FIELD.Innouts/3.0) AS INN,
																 SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																 SUM(FIELD.PO) AS PO,
																 SUM(FIELD.A) AS A,
																 SUM(FIELD.E) AS E,
																 CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
															FROM fieldings AS FIELD,
																 positions AS PO
														   WHERE PO.pos = FIELD.POS AND
																 FIELD.player_id = "' + @player + '" AND
																 FIELD.POS IN (SELECT POS
																				 FROM positions
																				WHERE field = "IF") 
																			 ORDER BY SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC')[0]
				if @playerFieldingIn.G == 0
					Struct.new("PlayerFielding", :G, :INN, :TC, :PO, :A, :E, :FPCT)
					@playerFieldingIn = Struct::PlayerFielding.new(0,0,0,0,0,0,0)
				end
				
				@playerFieldingOut = Fielding.find_by_sql('SELECT COUNT(FIELD.game_id) AS G,
																  SUM(FIELD.Innouts/3.0) AS INN,
																  SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																  SUM(FIELD.PO) AS PO,
																  SUM(FIELD.A) AS A,
																  SUM(FIELD.E) AS E,
																  CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
															 FROM fieldings AS FIELD,
																  positions AS PO
															WHERE PO.pos = FIELD.POS AND
																  FIELD.player_id = "' + @player + '" AND
																  FIELD.POS IN (SELECT POS
																				  FROM positions
																				 WHERE field = "OF") 
																			  ORDER BY SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) DESC')[0]
				if @playerFieldingOut.G == 0
					Struct.new("PlayerFielding", :G, :INN, :TC, :PO, :A, :E, :FPCT)
					@playerFieldingOut = Struct::PlayerFielding.new(0,0,0,0,0,0,0)
				end
				
				@playerFieldingTotal = Fielding.find_by_sql('SELECT COUNT(FIELD.game_id) AS G,
																	SUM(FIELD.Innouts/3.0) AS INN,
																	SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
																	SUM(FIELD.PO) AS PO,
																	SUM(FIELD.A) AS A,
																	SUM(FIELD.E) AS E,
																	CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
															   FROM fieldings AS FIELD,
																	positions AS PO
															  WHERE PO.pos = FIELD.POS AND
																	FIELD.player_id = "' + @player + '"')[0]
				@playerYearPitching = Pitching.find_by_sql('SELECT C.year,
																   COUNT(PIT.game_id) AS G,
																   SUM(PIT.W) AS W,
																   SUM(PIT.L) AS L,
																   SUM(PIT.IPouts/3.0) AS IP,
																   SUM(PIT.BAOpp) AS TBF,
																   SUM(PIT.H) AS H,
																   SUM(PIT.HR) AS HR,
																   SUM(PIT.SO) AS SO,
																   SUM(PIT.BB) AS BB,
																   SUM(PIT.IBB) AS IBB,
																   SUM(PIT.R) AS R,
																   SUM(PIT.ER) AS ER,
																   CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																   (SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
																   CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
																   CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
																   CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R5,
																   CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R7
															  FROM pitchings AS PIT, 
																   games AS G,
																   cups AS C 
															 WHERE PIT.player_id = "' + @player + '" AND
																   PIT.game_id = G.game_id AND
																   G.cup_id = C.cup_id
														  GROUP BY C.year')
				@playerPitchingSummary = Pitching.find_by_sql('SELECT COUNT(PIT.game_id) AS G,
																	  SUM(PIT.W) AS W,
																	  SUM(PIT.L) AS L,
																	  SUM(PIT.IPouts/3.0) AS IP,
																	  SUM(PIT.BAOpp) AS TBF,
																	  SUM(PIT.H) AS H,
																	  SUM(PIT.HR) AS HR,
																	  SUM(PIT.SO) AS SO,
																	  SUM(PIT.BB) AS BB,
																	  SUM(PIT.IBB) AS IBB,
																	  SUM(PIT.R) AS R,
																	  SUM(PIT.ER) AS ER,
																	  CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																	  (SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
																	  CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA5,
																	  CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS ERA7,
																	  CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R5,
																	  CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS SIGNED) AS DECIMAL)/1000.0 AS R7
																 FROM pitchings AS PIT
																WHERE PIT.player_id = "' + @player + '" ')[0]
				@playerPitchingFormal = playerPitchingClassifiedHelper('formal',@player)
				@playerPitchingOfficial = playerPitchingClassifiedHelper('official',@player)
				@playerPitchingFriendly = playerPitchingClassifiedHelper('friendly',@player)
				@playerPitchingStarter = playerPitchingClassifiedHelper('starter',@player)
				@playerPitchingReliever = playerPitchingClassifiedHelper('reliever',@player)
				
				@playerBattingMax = Batting.find_by_sql('SELECT MAX(BAT.AB+BAT.BB+BAT.IBB+BAT.SF) AS PA,
																MAX(BAT.AB) AS AB,
																MAX(BAT.H) AS H,
																MAX(BAT.H-BAT.B2-BAT.B3-BAT.HR) AS B1,
																MAX(BAT.B2) AS B2,
																MAX(BAT.B3) AS B3,
																MAX(BAT.HR) AS HR,
																MAX(BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3) AS TB,
																MAX(BAT.RBI) AS RBI,
																MAX(BAT.R) AS R,
																MAX(BAT.SO) AS SO,
																MAX(BAT.BB) AS BB,
																MAX(BAT.IBB) AS IBB,
																MAX(BAT.SF) AS SF,
																MAX(BAT.E) AS E
														   FROM battings AS BAT
														  WHERE BAT.player_id = "' + @player + '" ')[0]
				@playerPitchingMax = Pitching.find_by_sql('SELECT MAX(PIT.IPouts/3.0) AS IP,
																  MAX(PIT.BAOpp) AS TBF,
																  MAX(PIT.H) AS H,
																  MAX(PIT.HR) AS HR,
																  MAX(PIT.SO) AS SO,
																  MAX(PIT.BB) AS BB,
																  MAX(PIT.IBB) AS IBB,
																  MAX(PIT.R) AS R,
																  MAX(PIT.ER) AS ER
															 FROM pitchings AS PIT
															WHERE PIT.player_id = "' + @player + '" ')[0]
				
				if @playerBattingMax.PA == nil
					Struct.new("PlayerBattingMax", :player_id, :PA, :AB, :H, :B1, :B2, :B3, :HR, :TB, :RBI, :R, :SO, :BB, :IBB, :SF, :E)
					@playerBattingMax = Struct::PlayerBattingMax.new(@player,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
				end
				if @playerPitchingMax.TBF == nil
					Struct.new("PlayerPitchingMax", :player_id, :IP, :TBF, :H, :HR, :SO, :BB, :IBB, :R, :ER)
					@playerPitchingMax = Struct::PlayerPitchingMax.new(@player,0.0,0,0,0,0,0,0,0,0)
				end
				
				@playerBattingContinuity = Batting.find_by_sql('SELECT BAT.H,
																	   BAT.RBI,
																	   BAT.R,
																	   BAT.HR,
																	   BAT.SO
																  FROM battings AS BAT
																 WHERE BAT.player_id = "' + @player + '"
															  ORDER BY BAT.game_id')
				@playerPitchingContinuity = Pitching.find_by_sql('SELECT PIT.W,
																		 PIT.L,
																		 PIT.SO,
																		 PIT.HR,
																		 PIT.R
																	FROM pitchings AS PIT
																   WHERE PIT.player_id = "' + @player + '"
																ORDER BY PIT.game_id')
				@ArrayBat_H = Array.new
				@ArrayBat_RBI = Array.new
				@ArrayBat_R = Array.new
				@ArrayBat_HR = Array.new
				@ArrayBat_SO = Array.new
				@currentBat_HSort = 0
				@wildcardBat_HSort = 0
				@currentBat_NHSort = 0
				@wildcardBat_NHSort = 0
				@currentBat_SOSort = 0
				@wildcardBat_SOSort = 0
				@currentBat_NSOSort = 0
				@wildcardBat_NSOSort = 0
				@currentBat_RBISort = 0
				@wildcardBat_RBISort = 0
				@currentBat_RSort = 0
				@wildcardBat_RSort = 0
				@currentBat_HRSort = 0
				@wildcardBat_HRSort = 0
				
				@playerBattingContinuity.each do |batContinuity|
					@ArrayBat_H.push(batContinuity.H)
					@ArrayBat_RBI.push(batContinuity.RBI)
					@ArrayBat_R.push(batContinuity.R)
					@ArrayBat_HR.push(batContinuity.HR)
					@ArrayBat_SO.push(batContinuity.SO)
				end
				
				for i in 0..(@playerBattingContinuity.length - 1)
					# 安打
					@currentBat_HSort = (@ArrayBat_H[i] == 0)? (0):(@currentBat_HSort + 1)
					@wildcardBat_HSort = (@currentBat_HSort >= @wildcardBat_HSort)? (@currentBat_HSort):(@wildcardBat_HSort)
					# 無安打
					@currentBat_NHSort = (@ArrayBat_H[i] != 0)? (0):(@currentBat_NHSort + 1)
					@wildcardBat_NHSort = (@currentBat_NHSort >= @wildcardBat_NHSort)? (@currentBat_NHSort):(@wildcardBat_NHSort)
					# 三振
					@currentBat_SOSort = (@ArrayBat_SO[i] == 0)? (0):(@currentBat_SOSort + 1)
					@wildcardBat_SOSort = (@currentBat_SOSort >= @wildcardBat_SOSort)? (@currentBat_SOSort):(@wildcardBat_SOSort)
					# 無三振
					@currentBat_NSOSort = (@ArrayBat_SO[i] != 0)? (0):(@currentBat_NSOSort + 1)
					@wildcardBat_NSOSort = (@currentBat_NSOSort >= @wildcardBat_NSOSort)? (@currentBat_NSOSort):(@wildcardBat_NSOSort)
					# 打點
					@currentBat_RBISort = (@ArrayBat_RBI[i] == 0)? (0):(@currentBat_RBISort + 1)
					@wildcardBat_RBISort = (@currentBat_RBISort >= @wildcardBat_RBISort)? (@currentBat_RBISort):(@wildcardBat_RBISort)
					# 得分
					@currentBat_RSort = (@ArrayBat_R[i] == 0)? (0):(@currentBat_RSort + 1)
					@wildcardBat_RSort = (@currentBat_RSort >= @wildcardBat_RSort)? (@currentBat_RSort):(@wildcardBat_RSort)
					# 全壘打
					@currentBat_HRSort = (@ArrayBat_HR[i] == 0)? (0):(@currentBat_HRSort + 1)
					@wildcardBat_HRSort = (@currentBat_HRSort >= @wildcardBat_HRSort)? (@currentBat_HRSort):(@wildcardBat_HRSort)
				end
				
				@ArrayPit_W = Array.new
				@ArrayPit_L = Array.new
				@ArrayPit_SO = Array.new
				@ArrayPit_HR = Array.new
				@ArrayPit_R = Array.new
				@currentPit_WSort = 0
				@wildcardPit_WSort = 0
				@currentPit_LSort = 0
				@wildcardPit_LSort = 0
				@currentPit_SOSort = 0
				@wildcardPit_SOSort = 0
				@currentPit_HRSort = 0
				@wildcardPit_HRSort = 0
				@currentPit_RSort = 0
				@wildcardPit_RSort = 0
				@currentPit_NRSort = 0
				@wildcardPit_NRSort = 0
				
				@playerPitchingContinuity.each do |pitContinuity|
					@ArrayPit_W.push(pitContinuity.W)
					@ArrayPit_L.push(pitContinuity.L)
					@ArrayPit_SO.push(pitContinuity.SO)
					@ArrayPit_HR.push(pitContinuity.HR)
					@ArrayPit_R.push(pitContinuity.R)
				end
				
				for i in 0..(@playerPitchingContinuity.length - 1)
					# 勝, 無勝負關係要跳過
					@currentPit_WSort = (@ArrayPit_W[i] == 0)? ((@ArrayPit_L[i] == 0)? (@currentPit_WSort):(0)):(@currentPit_WSort + 1)
					@wildcardPit_WSort = (@currentPit_WSort >= @wildcardPit_WSort)? (@currentPit_WSort):(@wildcardPit_WSort)
					# 敗, 無勝負關係要跳過
					@currentPit_LSort = (@ArrayPit_L[i] == 0)? ((@ArrayPit_W[i] == 0)? (@currentPit_LSort):(0)):(@currentPit_LSort + 1)
					@wildcardPit_LSort = (@currentPit_LSort >= @wildcardPit_LSort)? (@currentPit_LSort):(@wildcardPit_LSort)
					# 三振
					@currentPit_SOSort = (@ArrayPit_SO[i] == 0)? (0):(@currentPit_SOSort + 1)
					@wildcardPit_SOSort = (@currentPit_SOSort >= @wildcardPit_SOSort)? (@currentPit_SOSort):(@wildcardPit_SOSort)
					# 失分
					@currentPit_RSort = (@ArrayPit_R[i] == 0)? (0):(@currentPit_RSort + 1)
					@wildcardPit_RSort = (@currentPit_RSort >= @wildcardPit_RSort)? (@currentPit_RSort):(@wildcardPit_RSort)
					# 無失分
					@currentPit_NRSort = (@ArrayPit_R[i] != 0)? (0):(@currentPit_NRSort + 1)
					@wildcardPit_NRSort = (@currentPit_NRSort >= @wildcardPit_NRSort)? (@currentPit_NRSort):(@wildcardPit_NRSort)
					# 被全壘打
					@currentPit_HRSort = (@ArrayPit_HR[i] == 0)? (0):(@currentPit_HRSort + 1)
					@wildcardPit_HRSort = (@currentPit_HRSort >= @wildcardPit_HRSort)? (@currentPit_HRSort):(@wildcardPit_HRSort)
				end
				
			end
		
		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	
	end
	
	def inactive_player
	
		if logged_in?

			@player_option = Array.new
			@allPlayer = Player.select('players.player_id').where('players.member = 0 AND players.player_id NOT LIKE "傭兵%"').order('players.player_id')
			@allPlayer.each do |eachPlayer|
				@player_option.push([eachPlayer.player_id,eachPlayer.player_id])
			end
			
		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
	def order
	
		if logged_in?

			# 每年有幾場比賽
			@gameNumberInEachYear = Cup.find_by_sql('SELECT cups.year,
															COUNT(*) AS gameNumber
													   FROM games,
															cups
													  WHERE games.cup_id = cups.cup_id
												   GROUP BY cups.year')
			@gameNumberInYear = Hash.new(0)
			@gameNumberInWildcard = 0
			@gameNumberInEachYear.each do |gNIEY|
				@gameNumberInYear[gNIEY.year.to_s] = gNIEY.gameNumber
				@gameNumberInWildcard += gNIEY.gameNumber
			end
			@gameNumberInYear['Wildcard'] = @gameNumberInWildcard
			
			@player = params[:player]
			@year = params[:year]
			@sql_year = (@year != 'Wildcard')? (' AND BAT.game_id IN (SELECT G.game_id FROM battings AS BAT, games AS G, cups AS C WHERE BAT.game_id = G.game_id and G.cup_id = C.cup_id and C.year = ' + @year.to_s + ' ) '):(' ')
			
			if @player == nil && @year == nil
			
				@year_option = Array.new
				@allyear = Cup.select('DISTINCT cups.year').order('cups.year')
				@allyear.each do |eachyear|
					@year_option.push([eachyear.year.to_s + "(" + (eachyear.year - 1911).to_s + "年度)",eachyear.year])
				end
				@year_option.push(["不分年度","Wildcard"])
			
			elsif @player == 'all'
			
				@order_allPlayer = Batting.find_by_sql('SELECT BAT.player_id,
															   BAT.order,
															   COUNT(BAT.game_id) AS G,
															   SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
															   SUM(BAT.AB) AS AB,
															   SUM(BAT.H) AS H,
															   SUM(BAT.B2) AS B2,
															   SUM(BAT.B3) AS B3,
															   SUM(BAT.HR) AS HR,
															   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
															   SUM(BAT.RBI) AS RBI,
															   SUM(BAT.R) AS R,
															   SUM(BAT.SO) AS SO,
															   SUM(BAT.BB) AS BB,
															   SUM(BAT.IBB) AS IBB,
															   SUM(BAT.SF) AS SF,
															   SUM(BAT.E) AS E,
															   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
															   (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
															   CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA
														  FROM battings AS BAT
														 WHERE BAT.player_id IN (SELECT player_id
																				   FROM players
																				  WHERE member = 1) ' + @sql_year +
																			  'GROUP BY BAT.player_id,
																						BAT.order
																			   ORDER BY BAT.order,
																						SUM(BAT.H)/(SUM(BAT.AB)+0.000000000000000000000000000000000000000001) DESC')
				@order_allPlayerSummary = Batting.find_by_sql('SELECT BAT.order,
																	  COUNT(BAT.game_id) AS times,
																	  SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																      SUM(BAT.AB) AS AB,
																      SUM(BAT.H) AS H,
																      SUM(BAT.B2) AS B2,
																      SUM(BAT.B3) AS B3,
																      SUM(BAT.HR) AS HR,
																      SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																      SUM(BAT.RBI) AS RBI,
																      SUM(BAT.R) AS R,
																      SUM(BAT.SO) AS SO,
																      SUM(BAT.BB) AS BB,
																      SUM(BAT.IBB) AS IBB,
																      SUM(BAT.SF) AS SF,
																      SUM(BAT.E) AS E,
																      CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																      CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
																      CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
																      (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
																      CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA
																 FROM battings AS BAT
																WHERE BAT.player_id IN (SELECT player_id
																						  FROM players
																						 WHERE member = 1 ) ' + @sql_year +
																					 'GROUP BY BAT.order
																					  ORDER BY BAT.order')
			else
				@order_eachgame = Batting.find_by_sql('SELECT BAT.game_id,
															  BAT.order,
															  (BAT.AB+BAT.BB+BAT.IBB+BAT.SF) AS PA,
															  BAT.AB,
															  BAT.H,
															  BAT.B2,
															  BAT.B3,
															  BAT.HR,
															  (BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3) AS TB,
															  BAT.RBI,
															  BAT.R,
															  BAT.SO,
															  BAT.BB,
															  BAT.IBB,
															  BAT.SF,
															  BAT.E,
															  CAST(CAST((BAT.H/(BAT.AB+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
															  CAST(CAST(((BAT.H+BAT.BB+BAT.IBB)/(BAT.AB+BAT.BB+BAT.IBB+BAT.SF+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
															  CAST(CAST(((BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3)/(BAT.AB+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
															  (CAST(CAST(((BAT.H+BAT.BB+BAT.IBB)/(BAT.AB+BAT.BB+BAT.IBB+BAT.SF+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3)/(BAT.AB+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
															  CAST(CAST((((BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3)+BAT.BB+BAT.IBB)/(BAT.AB-BAT.H+BAT.GIDP+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA
														 FROM battings AS BAT
														WHERE BAT.player_id = "' + @player + '" ' + @sql_year +
													'ORDER BY BAT.game_id')
				@order_eachorder = Batting.find_by_sql('SELECT BAT.order,
															   COUNT(BAT.game_id) AS G,
															   SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
															   SUM(BAT.AB) AS AB,
															   SUM(BAT.H) AS H,
															   SUM(BAT.B2) AS B2,
															   SUM(BAT.B3) AS B3,
															   SUM(BAT.HR) AS HR,
															   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
															   SUM(BAT.RBI) AS RBI,
															   SUM(BAT.R) AS R,
															   SUM(BAT.SO) AS SO,
															   SUM(BAT.BB) AS BB,
															   SUM(BAT.IBB) AS IBB,
															   SUM(BAT.SF) AS SF,
															   SUM(BAT.E) AS E,
															   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
															   (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
															   CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA
														  FROM battings AS BAT
														 WHERE BAT.player_id = "' + @player + '" ' + @sql_year +
													 'GROUP BY BAT.order
													  ORDER BY BAT.order')
				@order_playerSummary = Batting.find_by_sql('SELECT COUNT(BAT.game_id) AS G,
																   SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
																   SUM(BAT.AB) AS AB,
																   SUM(BAT.H) AS H,
																   SUM(BAT.B2) AS B2,
																   SUM(BAT.B3) AS B3,
																   SUM(BAT.HR) AS HR,
																   SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
																   SUM(BAT.RBI) AS RBI,
																   SUM(BAT.R) AS R,
																   SUM(BAT.SO) AS SO,
																   SUM(BAT.BB) AS BB,
																   SUM(BAT.IBB) AS IBB,
																   SUM(BAT.SF) AS SF,
																   SUM(BAT.E) AS E,
																   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
																   CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
																   CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
																   (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
																   CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA
															  FROM battings AS BAT
															 WHERE BAT.player_id = "' + @player + '" ' + @sql_year)[0]
			end
			
		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
	def lucky
	
		if logged_in?

			@active = ' AND BAT.player_id IN (SELECT player_id FROM players WHERE players.member = 1 ) '
			
			@lucky_win = Batting.find_by_sql('SELECT MBR.name,
													 Bat.player_id,
													 SUM(H) AS H,
													 SUM(AB) AS AB,
													 COUNT(*) AS times
												FROM games AS G,
													 battings AS BAT,
													 members AS MBR
											   WHERE G.game_id = BAT.game_id AND
													 ((BAT.team_id = G.home_team_id AND home_score > away_score) OR
													  (BAT.team_id = G.away_team_id AND home_score < away_score)) ' + @active + ' AND
													 BAT.player_id = MBR.id
										    GROUP BY Bat.player_id')
			@lucky_lose = Batting.find_by_sql('SELECT MBR.name,
													  Bat.player_id,
													  SUM(H) AS H,
													  SUM(AB) AS AB,
													  COUNT(*) AS times
												 FROM games AS G,
													  battings AS BAT,
													  members AS MBR
											    WHERE G.game_id = BAT.game_id AND
													  ((BAT.team_id = G.home_team_id AND home_score < away_score) OR
													   (BAT.team_id = G.away_team_id AND home_score > away_score)) ' + @active + ' AND
													  BAT.player_id = MBR.id
											 GROUP BY Bat.player_id')
			@lucky_game = Batting.find_by_sql('SELECT MBR.name,
													  Bat.player_id,
													  SUM(H) AS H,
													  SUM(AB) AS AB,
													  COUNT(*) AS times
												 FROM games AS G,
													  battings AS BAT,
													  members AS MBR
											    WHERE G.game_id = BAT.game_id ' + @active + ' AND
													  BAT.player_id = MBR.id
											 GROUP BY Bat.player_id')
			
			@win_times = Hash.new(0)
			@win_H = Hash.new(0)
			@win_AB = Hash.new(0)
			if @lucky_win.size > 0
				@lucky_win.each do |eachWin|
					@win_times[eachWin.player_id] = eachWin.times
					@win_H[eachWin.player_id] = eachWin.H
					@win_AB[eachWin.player_id] = eachWin.AB
				end
			end
			
			@lose_times = Hash.new(0)
			@lose_H = Hash.new(0)
			@lose_AB = Hash.new(0)
			if @lucky_lose.size > 0
				@lucky_lose.each do |eachLose|
					@lose_times[eachLose.player_id] = eachLose.times
					@lose_H[eachLose.player_id] = eachLose.H
					@lose_AB[eachLose.player_id] = eachLose.AB
				end
			end
			
			@arrayID2Name = Hash.new
			@game_times = Hash.new(0)
			@game_H = Hash.new(0)
			@game_AB = Hash.new(0)
			if @lucky_game.size > 0
				@lucky_game.each do |eachGame|
					@game_times[eachGame.player_id] = eachGame.times
					@game_H[eachGame.player_id] = eachGame.H
					@game_AB[eachGame.player_id] = eachGame.AB
					@arrayID2Name[eachGame.player_id] = (eachGame.name == nil)? (eachGame.player_id):(eachGame.name)
				end
			end
			
			@luckySort = Array.new
			@win_times.each do |key,value|
				@luckySort.push([key,(value.to_f / @game_times[key])])
			end
			
			@luckySort.sort!{|a,b| b[1] <=> a[1]}
			
			@riderSort = Array.new(0)
			@win_times.each do |key,value|
				@winRate = (@win_AB[key] != 0)? (@win_H[key].to_f / @win_AB[key]):(0)
				@totalRate = (@game_AB[key] != 0)? (@game_H[key].to_f / @game_AB[key]):(0)
				@riderSort.push([key,@winRate - @totalRate])
			end
			
			@riderSort.sort!{|a,b| b[1] <=> a[1]}
			
		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
	def continuity
	
		if logged_in?

			@allMember = Player.select('players.player_id, members.name').where('players.member = 1').joins('LEFT JOIN members ON members.id = players.player_id').order('players.player_id')
			@currentBat_HSort = Hash.new{0}
			@wildcardBat_HSort = Hash.new{0}
			@currentBat_NHSort = Hash.new{0}
			@wildcardBat_NHSort = Hash.new{0}
			@currentBat_RBISort = Hash.new{0}
			@wildcardBat_RBISort = Hash.new{0}
			@currentBat_RSort = Hash.new{0}
			@wildcardBat_RSort = Hash.new{0}
			@currentBat_HRSort = Hash.new{0}
			@wildcardBat_HRSort = Hash.new{0}
			@currentFld_ESort = Hash.new{0}
			@wildcardFld_ESort = Hash.new{0}
			@currentFld_NESort = Hash.new{0}
			@wildcardFld_NESort = Hash.new{0}
			@arrayID2Name = Hash.new
			
			@allMember.each do |eachMember|
				
				@arrayID2Name[eachMember.player_id] = (eachMember.name == nil)? (eachMember.player_id):(eachMember.name)
				@battingContinuity = Batting.find_by_sql('SELECT BAT.H,
																 BAT.RBI,
																 BAT.R,
																 BAT.HR
															FROM battings AS BAT
														   WHERE BAT.player_id = "' + eachMember.player_id + '"
														ORDER BY BAT.game_id')
				@fieldingContinuity = Fielding.find_by_sql('SELECT SUM(FIELD.E) AS E
															  FROM fieldings AS FIELD
															 WHERE FIELD.player_id = "' + eachMember.player_id + '"
														  GROUP BY FIELD.game_id
														  ORDER BY FIELD.game_id')
				@ArrayBat_H = Array.new
				@ArrayBat_RBI = Array.new
				@ArrayBat_R = Array.new
				@ArrayBat_HR = Array.new
				@ArrayFld_E = Array.new
				
				@battingContinuity.each do |batContinuity|
					@ArrayBat_H.push(batContinuity.H)
					@ArrayBat_RBI.push(batContinuity.RBI)
					@ArrayBat_R.push(batContinuity.R)
					@ArrayBat_HR.push(batContinuity.HR)
				end
				
				@fieldingContinuity.each do |fldContinuity|
					@ArrayFld_E.push(fldContinuity.E)
				end
				
				for i in 0..(@battingContinuity.length - 1)
					# 安打
					@currentBat_HSort[eachMember.player_id] = (@ArrayBat_H[i] == 0)? (0):(@currentBat_HSort[eachMember.player_id] + 1)
					@wildcardBat_HSort[eachMember.player_id] = (@currentBat_HSort[eachMember.player_id] >= @wildcardBat_HSort[eachMember.player_id])? (@currentBat_HSort[eachMember.player_id]):(@wildcardBat_HSort[eachMember.player_id])
					# 無安打
					@currentBat_NHSort[eachMember.player_id] = (@ArrayBat_H[i] != 0)? (0):(@currentBat_NHSort[eachMember.player_id] + 1)
					@wildcardBat_NHSort[eachMember.player_id] = (@currentBat_NHSort[eachMember.player_id] >= @wildcardBat_NHSort[eachMember.player_id])? (@currentBat_NHSort[eachMember.player_id]):(@wildcardBat_NHSort[eachMember.player_id])
					# 打點
					@currentBat_RBISort[eachMember.player_id] = (@ArrayBat_RBI[i] == 0)? (0):(@currentBat_RBISort[eachMember.player_id] + 1)
					@wildcardBat_RBISort[eachMember.player_id] = (@currentBat_RBISort[eachMember.player_id] >= @wildcardBat_RBISort[eachMember.player_id])? (@currentBat_RBISort[eachMember.player_id]):(@wildcardBat_RBISort[eachMember.player_id])
					# 得分
					@currentBat_RSort[eachMember.player_id] = (@ArrayBat_R[i] == 0)? (0):(@currentBat_RSort[eachMember.player_id] + 1)
					@wildcardBat_RSort[eachMember.player_id] = (@currentBat_RSort[eachMember.player_id] >= @wildcardBat_RSort[eachMember.player_id])? (@currentBat_RSort[eachMember.player_id]):(@wildcardBat_RSort[eachMember.player_id])
					# 全壘打
					@currentBat_HRSort[eachMember.player_id] = (@ArrayBat_HR[i] == 0)? (0):(@currentBat_HRSort[eachMember.player_id] + 1)
					@wildcardBat_HRSort[eachMember.player_id] = (@currentBat_HRSort[eachMember.player_id] >= @wildcardBat_HRSort[eachMember.player_id])? (@currentBat_HRSort[eachMember.player_id]):(@wildcardBat_HRSort[eachMember.player_id])
				end
				
				for i in 0..(@fieldingContinuity.length - 1)
					# 安打
					@currentFld_ESort[eachMember.player_id] = (@ArrayFld_E[i] == 0)? (0):(@currentFld_ESort[eachMember.player_id] + 1)
					@wildcardFld_ESort[eachMember.player_id] = (@currentFld_ESort[eachMember.player_id] >= @wildcardFld_ESort[eachMember.player_id])? (@currentFld_ESort[eachMember.player_id]):(@wildcardFld_ESort[eachMember.player_id])
					# 無安打
					@currentFld_NESort[eachMember.player_id] = (@ArrayFld_E[i] != 0)? (0):(@currentFld_NESort[eachMember.player_id] + 1)
					@wildcardFld_NESort[eachMember.player_id] = (@currentFld_NESort[eachMember.player_id] >= @wildcardFld_NESort[eachMember.player_id])? (@currentFld_NESort[eachMember.player_id]):(@wildcardFld_NESort[eachMember.player_id])
				end
				
			end
			
			@currentBat_HSort = @currentBat_HSort.sort_by {|k,v| v}.reverse.to_h
			@currentFld_ESort = @currentFld_ESort.sort_by {|k,v| v}.reverse.to_h
			
			@allPitcher = Player.find_by_sql('SELECT DISTINCT PIT.player_id
												FROM pitchings AS PIT,
													 players AS PLY
											   WHERE PIT.player_id = PLY.player_id AND
													 PLY.member = 1
											ORDER BY PIT.player_id')
			
			@currentPit_WSort = Hash.new{0}
			@wildcardPit_WSort = Hash.new{0}
			@currentPit_LSort = Hash.new{0}
			@wildcardPit_LSort = Hash.new{0}
			@currentPit_SOSort = Hash.new{0}
			@wildcardPit_SOSort = Hash.new{0}
			@currentPit_HRSort = Hash.new{0}
			@wildcardPit_HRSort = Hash.new{0}
			
			@allPitcher.each do |eachPitcher|
				
				@pitchingContinuity = Pitching.find_by_sql('SELECT PIT.W,
																   PIT.L,
																   PIT.SO,
																   PIT.HR
															  FROM pitchings AS PIT
															 WHERE PIT.player_id = "' + eachPitcher.player_id + '"
														  ORDER BY PIT.game_id')
				@ArrayPit_W = Array.new
				@ArrayPit_L = Array.new
				@ArrayPit_SO = Array.new
				@ArrayPit_HR = Array.new
				
				@pitchingContinuity.each do |pitContinuity|
					@ArrayPit_W.push(pitContinuity.W)
					@ArrayPit_L.push(pitContinuity.L)
					@ArrayPit_SO.push(pitContinuity.SO)
					@ArrayPit_HR.push(pitContinuity.HR)
				end
				
				for i in 0..(@pitchingContinuity.length - 1)
					# 勝, 無勝負關係要跳過
					@currentPit_WSort[eachPitcher.player_id] = (@ArrayPit_W[i] == 0)? ((@ArrayPit_L[i] == 0)? (@currentPit_WSort[eachPitcher.player_id]):(0)):(@currentPit_WSort[eachPitcher.player_id] + 1)
					@wildcardPit_WSort[eachPitcher.player_id] = (@currentPit_WSort[eachPitcher.player_id] >= @wildcardPit_WSort[eachPitcher.player_id])? (@currentPit_WSort[eachPitcher.player_id]):(@wildcardPit_WSort[eachPitcher.player_id])
					# 敗, 無勝負關係要跳過
					@currentPit_LSort[eachPitcher.player_id] = (@ArrayPit_L[i] == 0)? ((@ArrayPit_W[i] == 0)? (@currentPit_LSort[eachPitcher.player_id]):(0)):(@currentPit_LSort[eachPitcher.player_id] + 1)
					@wildcardPit_LSort[eachPitcher.player_id] = (@currentPit_LSort[eachPitcher.player_id] >= @wildcardPit_LSort[eachPitcher.player_id])? (@currentPit_LSort[eachPitcher.player_id]):(@wildcardPit_LSort[eachPitcher.player_id])
					# 三振
					@currentPit_SOSort[eachPitcher.player_id] = (@ArrayPit_SO[i] == 0)? (0):(@currentPit_SOSort[eachPitcher.player_id] + 1)
					@wildcardPit_SOSort[eachPitcher.player_id] = (@currentPit_SOSort[eachPitcher.player_id] >= @wildcardPit_SOSort[eachPitcher.player_id])? (@currentPit_SOSort[eachPitcher.player_id]):(@wildcardPit_SOSort[eachPitcher.player_id])
					# 被全壘打
					@currentPit_HRSort[eachPitcher.player_id] = (@ArrayPit_HR[i] == 0)? (0):(@currentPit_HRSort[eachPitcher.player_id] + 1)
					@wildcardPit_HRSort[eachPitcher.player_id] = (@currentPit_HRSort[eachPitcher.player_id] >= @wildcardPit_HRSort[eachPitcher.player_id])? (@currentPit_HRSort[eachPitcher.player_id]):(@wildcardPit_HRSort[eachPitcher.player_id])
				end
			
			end
			
			@currentPit_WSort = @currentPit_WSort.sort_by {|k,v| v}.reverse.to_h
			
		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
	def max
	
		if logged_in?

			@top = 10
			@allMember = Player.select('players.player_id, members.name').where('players.member = 1').joins('LEFT JOIN members ON members.id = players.player_id').order('players.player_id')
			@arrayID2Name = Hash.new
			@allMember.each do |eachMember|
				@arrayID2Name[eachMember.player_id] = (eachMember.name == nil)? (eachMember.player_id):(eachMember.name)
			end	
			# Batting
			@max_bat_H = Batting.find_by_sql('SELECT BAT.player_id,
													 BAT.H,
													 COUNT(*) AS G
												FROM battings AS BAT,
													 players AS PLY
											   WHERE BAT.player_id = PLY.player_id AND
													 PLY.member = 1
											GROUP BY BAT.player_id,
													 BAT.H
											ORDER BY BAT.H DESC,
													 COUNT(*) DESC
											   LIMIT ' + @top.to_s)
			@lowerBound_bat_H = @max_bat_H[@max_bat_H.size - 1].H
			@max_bat_H = Batting.find_by_sql('SELECT BAT.player_id,
													 BAT.H,
													 COUNT(*) AS G
												FROM battings AS BAT,
													 players AS PLY
											   WHERE BAT.player_id = PLY.player_id AND
													 PLY.member = 1 AND
													 BAT.H >= ' + @lowerBound_bat_H.to_s + '
											GROUP BY BAT.player_id,
													 BAT.H
											ORDER BY BAT.H DESC,
													 COUNT(*) DESC')
			@max_bat_RBI = Batting.find_by_sql('SELECT BAT.player_id,
													   BAT.RBI,
													   COUNT(*) AS G
												  FROM battings AS BAT,
													   players AS PLY
											     WHERE BAT.player_id = PLY.player_id AND
													   PLY.member = 1
											  GROUP BY BAT.player_id,
													   BAT.RBI
											  ORDER BY BAT.RBI DESC,
													   COUNT(*) DESC
												 LIMIT ' + @top.to_s)
			@lowerBound_bat_RBI = @max_bat_RBI[@max_bat_RBI.size - 1].RBI
			@max_bat_RBI = Batting.find_by_sql('SELECT BAT.player_id,
													   BAT.RBI,
													   COUNT(*) AS G
												  FROM battings AS BAT,
													   players AS PLY
											     WHERE BAT.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   BAT.RBI >= ' + @lowerBound_bat_RBI.to_s + '
											  GROUP BY BAT.player_id,
													   BAT.RBI
											  ORDER BY BAT.RBI DESC,
													   COUNT(*) DESC')
			@max_bat_HR = Batting.find_by_sql('SELECT BAT.player_id,
													  BAT.HR,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1
											 GROUP BY BAT.player_id,
													  BAT.HR
											 ORDER BY BAT.HR DESC,
													  COUNT(*) DESC
												LIMIT ' + @top.to_s)
			@lowerBound_bat_HR = @max_bat_HR[@max_bat_HR.size - 1].HR
			@max_bat_HR = Batting.find_by_sql('SELECT BAT.player_id,
													  BAT.HR,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1 AND
													  BAT.HR >= ' + @lowerBound_bat_HR.to_s + '
											  GROUP BY BAT.player_id,
													   BAT.HR
											  ORDER BY BAT.HR DESC,
													   COUNT(*) DESC')
			@max_bat_R = Batting.find_by_sql('SELECT BAT.player_id,
													  BAT.R,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1
											 GROUP BY BAT.player_id,
													  BAT.R
											 ORDER BY BAT.R DESC,
													  COUNT(*) DESC
												LIMIT ' + @top.to_s)
			@lowerBound_bat_R = @max_bat_R[@max_bat_R.size - 1].R
			@max_bat_R = Batting.find_by_sql('SELECT BAT.player_id,
													  BAT.R,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1 AND
													  BAT.R >= ' + @lowerBound_bat_R.to_s + '
											  GROUP BY BAT.player_id,
													   BAT.R
											  ORDER BY BAT.R DESC,
													   COUNT(*) DESC')
			@max_bat_SO = Batting.find_by_sql('SELECT BAT.player_id,
													  BAT.SO,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1
											 GROUP BY BAT.player_id,
													  BAT.SO
											 ORDER BY BAT.SO DESC,
													  COUNT(*) DESC
												LIMIT ' + @top.to_s)
			@lowerBound_bat_SO = @max_bat_SO[@max_bat_SO.size - 1].SO
			@max_bat_SO = Batting.find_by_sql('SELECT BAT.player_id,
													  BAT.SO,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1 AND
													  BAT.SO >= ' + @lowerBound_bat_SO.to_s + '
											  GROUP BY BAT.player_id,
													   BAT.SO
											  ORDER BY BAT.SO DESC,
													   COUNT(*) DESC')
			@max_bat_BB = Batting.find_by_sql('SELECT BAT.player_id,
													  BAT.BB,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1
											 GROUP BY BAT.player_id,
													  BAT.BB
											 ORDER BY BAT.BB DESC,
													  COUNT(*) DESC
												LIMIT ' + @top.to_s)
			@lowerBound_bat_BB = @max_bat_BB[@max_bat_BB.size - 1].BB
			@max_bat_BB = Batting.find_by_sql('SELECT BAT.player_id,
													  BAT.BB,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1 AND
													  BAT.BB >= ' + @lowerBound_bat_BB.to_s + '
											  GROUP BY BAT.player_id,
													   BAT.BB
											  ORDER BY BAT.BB DESC,
													   COUNT(*) DESC')
			@max_bat_TB = Batting.find_by_sql('SELECT BAT.player_id,
													  (BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3) AS TB,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1
											 GROUP BY BAT.player_id,
													  (BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3)
											 ORDER BY (BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3) DESC,
													  COUNT(*) DESC
												LIMIT ' + @top.to_s)
			@lowerBound_bat_TB = @max_bat_TB[@max_bat_TB.size - 1].TB
			@max_bat_TB = Batting.find_by_sql('SELECT BAT.player_id,
													  (BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3) AS TB,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1 AND
													  (BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3) >= ' + @lowerBound_bat_TB.to_s + '
											  GROUP BY BAT.player_id,
													   (BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3)
											  ORDER BY (BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3) DESC,
													   COUNT(*) DESC')
			@max_bat_B2 = Batting.find_by_sql('SELECT BAT.player_id,
													  BAT.B2,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1
											 GROUP BY BAT.player_id,
													  BAT.B2
											 ORDER BY BAT.B2 DESC,
													  COUNT(*) DESC
												LIMIT ' + @top.to_s)
			@lowerBound_bat_B2 = @max_bat_B2[@max_bat_B2.size - 1].B2
			@max_bat_B2 = Batting.find_by_sql('SELECT BAT.player_id,
													  BAT.B2,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1 AND
													  BAT.B2 >= ' + @lowerBound_bat_B2.to_s + '
											  GROUP BY BAT.player_id,
													   BAT.B2
											  ORDER BY BAT.B2 DESC,
													   COUNT(*) DESC')
			@max_bat_B3 = Batting.find_by_sql('SELECT BAT.player_id,
													  BAT.B3,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1
											 GROUP BY BAT.player_id,
													  BAT.B3
											 ORDER BY BAT.B3 DESC,
													  COUNT(*) DESC
												LIMIT ' + @top.to_s)
			@lowerBound_bat_B3 = @max_bat_B3[@max_bat_B3.size - 1].B3
			@max_bat_B3 = Batting.find_by_sql('SELECT BAT.player_id,
													  BAT.B3,
													  COUNT(*) AS G
												 FROM battings AS BAT,
													  players AS PLY
											    WHERE BAT.player_id = PLY.player_id AND
													  PLY.member = 1 AND
													  BAT.B3 >= ' + @lowerBound_bat_B3.to_s + '
											  GROUP BY BAT.player_id,
													   BAT.B3
											  ORDER BY BAT.B3 DESC,
													   COUNT(*) DESC')
			# Fielding										   
			@top = 8
			@max_fld_TC = Fielding.find_by_sql('SELECT FIELD.player_id,
													   FIELD.PO+FIELD.K+FIELD.A+FIELD.E AS TC,
													   COUNT(*) AS G
												  FROM fieldings AS FIELD,
													   players AS PLY
												 WHERE FIELD.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   FIELD.POS <> "C"
											  GROUP BY FIELD.player_id,
													   FIELD.PO+FIELD.K+FIELD.A+FIELD.E
											  ORDER BY FIELD.PO+FIELD.K+FIELD.A+FIELD.E DESC,
													   COUNT(*) DESC
												 LIMIT ' + @top.to_s)
			@lowerBound_fld_TC = @max_fld_TC[@max_fld_TC.size - 1].TC
			@max_fld_TC = Fielding.find_by_sql('SELECT FIELD.player_id,
													   FIELD.PO+FIELD.K+FIELD.A+FIELD.E AS TC,
													   COUNT(*) AS G
												  FROM fieldings AS FIELD,
													   players AS PLY
											     WHERE FIELD.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   FIELD.POS <> "C" AND
													   FIELD.PO+FIELD.K+FIELD.A+FIELD.E >= ' + @lowerBound_fld_TC.to_s + '
											  GROUP BY FIELD.player_id,
													   FIELD.PO+FIELD.K+FIELD.A+FIELD.E
											  ORDER BY FIELD.PO+FIELD.K+FIELD.A+FIELD.E DESC,
													   COUNT(*) DESC')
			@max_fld_PO = Fielding.find_by_sql('SELECT FIELD.player_id,
													   FIELD.PO,
													   COUNT(*) AS G
												  FROM fieldings AS FIELD,
													   players AS PLY
												 WHERE FIELD.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   FIELD.POS <> "C"
											  GROUP BY FIELD.player_id,
													   FIELD.PO
											  ORDER BY FIELD.PO DESC,
													   COUNT(*) DESC
												 LIMIT ' + @top.to_s)
			@lowerBound_fld_PO = @max_fld_PO[@max_fld_PO.size - 1].PO
			@max_fld_PO = Fielding.find_by_sql('SELECT FIELD.player_id,
													   FIELD.PO,
													   COUNT(*) AS G
												  FROM fieldings AS FIELD,
													   players AS PLY
											     WHERE FIELD.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   FIELD.POS <> "C" AND
													   FIELD.PO >= ' + @lowerBound_fld_PO.to_s + '
											  GROUP BY FIELD.player_id,
													   FIELD.PO
											  ORDER BY FIELD.PO DESC,
													   COUNT(*) DESC')
			@max_fld_A = Fielding.find_by_sql('SELECT FIELD.player_id,
													   FIELD.A,
													   COUNT(*) AS G
												  FROM fieldings AS FIELD,
													   players AS PLY
												 WHERE FIELD.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   FIELD.POS <> "C"
											  GROUP BY FIELD.player_id,
													   FIELD.A
											  ORDER BY FIELD.A DESC,
													   COUNT(*) DESC
												 LIMIT ' + @top.to_s)
			@lowerBound_fld_A = @max_fld_A[@max_fld_A.size - 1].A
			@max_fld_A = Fielding.find_by_sql('SELECT FIELD.player_id,
													   FIELD.A,
													   COUNT(*) AS G
												  FROM fieldings AS FIELD,
													   players AS PLY
											     WHERE FIELD.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   FIELD.POS <> "C" AND
													   FIELD.A >= ' + @lowerBound_fld_A.to_s + '
											  GROUP BY FIELD.player_id,
													   FIELD.A
											  ORDER BY FIELD.A DESC,
													   COUNT(*) DESC')
			@max_fld_E = Fielding.find_by_sql('SELECT FIELD.player_id,
													   FIELD.E,
													   COUNT(*) AS G
												  FROM fieldings AS FIELD,
													   players AS PLY
												 WHERE FIELD.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   FIELD.POS <> "C"
											  GROUP BY FIELD.player_id,
													   FIELD.E
											  ORDER BY FIELD.E DESC,
													   COUNT(*) DESC
												 LIMIT ' + @top.to_s)
			@lowerBound_fld_E = @max_fld_E[@max_fld_E.size - 1].E
			@max_fld_E = Fielding.find_by_sql('SELECT FIELD.player_id,
													   FIELD.E,
													   COUNT(*) AS G
												  FROM fieldings AS FIELD,
													   players AS PLY
											     WHERE FIELD.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   FIELD.POS <> "C" AND
													   FIELD.E >= ' + @lowerBound_fld_E.to_s + '
											  GROUP BY FIELD.player_id,
													   FIELD.E
											  ORDER BY FIELD.E DESC,
													   COUNT(*) DESC')
			# Pitching
			@top = 8
			@max_pit_SO = Pitching.find_by_sql('SELECT PIT.player_id,
													   PIT.SO,
													   COUNT(*) AS G
												  FROM pitchings AS PIT,
													   players AS PLY
												 WHERE PIT.player_id = PLY.player_id AND
													   PLY.member = 1
											  GROUP BY PIT.player_id,
													   PIT.SO
											  ORDER BY PIT.SO DESC,
													   COUNT(*) DESC
												 LIMIT ' + @top.to_s)
			@lowerBound_pit_SO = @max_pit_SO[@max_pit_SO.size - 1].SO
			@max_pit_SO = Pitching.find_by_sql('SELECT PIT.player_id,
													   PIT.SO,
													   COUNT(*) AS G
												  FROM pitchings AS PIT,
													   players AS PLY
											     WHERE PIT.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   PIT.SO >= ' + @lowerBound_pit_SO.to_s + '
											  GROUP BY PIT.player_id,
													   PIT.SO
											  ORDER BY PIT.SO DESC,
													   COUNT(*) DESC')
			@max_pit_BB = Pitching.find_by_sql('SELECT PIT.player_id,
													   PIT.BB,
													   COUNT(*) AS G
												  FROM pitchings AS PIT,
													   players AS PLY
												 WHERE PIT.player_id = PLY.player_id AND
													   PLY.member = 1
											  GROUP BY PIT.player_id,
													   PIT.BB
											  ORDER BY PIT.BB DESC,
													   COUNT(*) DESC
												 LIMIT ' + @top.to_s)
			@lowerBound_pit_BB = @max_pit_BB[@max_pit_BB.size - 1].BB
			@max_pit_BB = Pitching.find_by_sql('SELECT PIT.player_id,
													   PIT.BB,
													   COUNT(*) AS G
												  FROM pitchings AS PIT,
													   players AS PLY
											     WHERE PIT.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   PIT.BB >= ' + @lowerBound_pit_BB.to_s + '
											  GROUP BY PIT.player_id,
													   PIT.BB
											  ORDER BY PIT.BB DESC,
													   COUNT(*) DESC')
			@max_pit_ER = Pitching.find_by_sql('SELECT PIT.player_id,
													   PIT.ER,
													   COUNT(*) AS G
												  FROM pitchings AS PIT,
													   players AS PLY
												 WHERE PIT.player_id = PLY.player_id AND
													   PLY.member = 1
											  GROUP BY PIT.player_id,
													   PIT.ER
											  ORDER BY PIT.ER DESC,
													   COUNT(*) DESC
												 LIMIT ' + @top.to_s)
			@lowerBound_pit_ER = @max_pit_ER[@max_pit_ER.size - 1].ER
			@max_pit_ER = Pitching.find_by_sql('SELECT PIT.player_id,
													   PIT.ER,
													   COUNT(*) AS G
												  FROM pitchings AS PIT,
													   players AS PLY
											     WHERE PIT.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   PIT.ER >= ' + @lowerBound_pit_ER.to_s + '
											  GROUP BY PIT.player_id,
													   PIT.ER
											  ORDER BY PIT.ER DESC,
													   COUNT(*) DESC')
			@max_pit_R = Pitching.find_by_sql('SELECT PIT.player_id,
													   PIT.R,
													   COUNT(*) AS G
												  FROM pitchings AS PIT,
													   players AS PLY
												 WHERE PIT.player_id = PLY.player_id AND
													   PLY.member = 1
											  GROUP BY PIT.player_id,
													   PIT.R
											  ORDER BY PIT.R DESC,
													   COUNT(*) DESC
												 LIMIT ' + @top.to_s)
			@lowerBound_pit_R = @max_pit_R[@max_pit_R.size - 1].R
			@max_pit_R = Pitching.find_by_sql('SELECT PIT.player_id,
													   PIT.R,
													   COUNT(*) AS G
												  FROM pitchings AS PIT,
													   players AS PLY
											     WHERE PIT.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   PIT.R >= ' + @lowerBound_pit_R.to_s + '
											  GROUP BY PIT.player_id,
													   PIT.R
											  ORDER BY PIT.R DESC,
													   COUNT(*) DESC')
			@max_pit_H = Pitching.find_by_sql('SELECT PIT.player_id,
													   PIT.H,
													   COUNT(*) AS G
												  FROM pitchings AS PIT,
													   players AS PLY
												 WHERE PIT.player_id = PLY.player_id AND
													   PLY.member = 1
											  GROUP BY PIT.player_id,
													   PIT.H
											  ORDER BY PIT.H DESC,
													   COUNT(*) DESC
												 LIMIT ' + @top.to_s)
			@lowerBound_pit_H = @max_pit_H[@max_pit_H.size - 1].H
			@max_pit_H = Pitching.find_by_sql('SELECT PIT.player_id,
													   PIT.H,
													   COUNT(*) AS G
												  FROM pitchings AS PIT,
													   players AS PLY
											     WHERE PIT.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   PIT.H >= ' + @lowerBound_pit_H.to_s + '
											  GROUP BY PIT.player_id,
													   PIT.H
											  ORDER BY PIT.H DESC,
													   COUNT(*) DESC')
			@max_pit_HR = Pitching.find_by_sql('SELECT PIT.player_id,
													   PIT.HR,
													   COUNT(*) AS G
												  FROM pitchings AS PIT,
													   players AS PLY
												 WHERE PIT.player_id = PLY.player_id AND
													   PLY.member = 1
											  GROUP BY PIT.player_id,
													   PIT.HR
											  ORDER BY PIT.HR DESC,
													   COUNT(*) DESC
												 LIMIT ' + @top.to_s)
			@lowerBound_pit_HR = @max_pit_HR[@max_pit_HR.size - 1].HR
			@max_pit_HR = Pitching.find_by_sql('SELECT PIT.player_id,
													   PIT.HR,
													   COUNT(*) AS G
												  FROM pitchings AS PIT,
													   players AS PLY
											     WHERE PIT.player_id = PLY.player_id AND
													   PLY.member = 1 AND
													   PIT.HR >= ' + @lowerBound_pit_HR.to_s + '
											  GROUP BY PIT.player_id,
													   PIT.HR
											  ORDER BY PIT.HR DESC,
													   COUNT(*) DESC')
		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
	def latest
	
		if logged_in?

			@default_top = 5
			@default_counter = 23
			@top = @default_top
			if params[:top] != nil && params[:top].to_i >= 1 && params[:top].to_i <= 10
				@top = params[:top].to_i
			end
			
			
			@top_option = Array.new
			for t in 1..10
				@top_option.push(["近 " + t.to_s + " 場",t])
			end
			
			@allActivePlayer = Hash.new
			@allActivePlayerQuery = Player.select('players.player_id, members.name')
										  .where('players.active = 1')
										  .joins('LEFT JOIN members ON members.id = players.player_id')
			
			@allyear = Cup.select('DISTINCT cups.year').order('cups.year DESC')
			@year = @allyear[0].year
			
			Struct.new("PlayerBatting", :PA, :AB, :H, :B2, :B3, :HR, :TB, :RBI, :R, :SO, :BB, :IBB, :SF, :E, :AVG, :OBP, :SLG, :OPS, :TA)
			Struct.new("PlayerFielding", :INN, :TC, :PO, :A, :E, :FPCT)
			@HashPlayerBatting = Hash.new
			@HashPlayerFielding = Hash.new
			@allActivePlayerQuery.each do |eachPlayer|
				
				if eachPlayer.name == nil
					@allActivePlayer[eachPlayer.player_id] = eachPlayer.player_id
				else
					@allActivePlayer[eachPlayer.player_id] = eachPlayer.name
				end
				
				@playerBatting = Batting.find_by_sql('SELECT SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF) AS PA,
															 SUM(BAT.AB) AS AB,
															 SUM(BAT.H) AS H,
															 SUM(BAT.B2) AS B2,
															 SUM(BAT.B3) AS B3,
															 SUM(BAT.HR) AS HR,
															 SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3 AS TB,
															 SUM(BAT.RBI) AS RBI,
															 SUM(BAT.R) AS R,
															 SUM(BAT.SO) AS SO,
															 SUM(BAT.BB) AS BB,
															 SUM(BAT.IBB) AS IBB,
															 SUM(BAT.SF) AS SF,
															 SUM(BAT.E) AS E,
															 CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS AVG,
															 CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS OBP,
															 CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS SLG,
															 (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0) AS OPS,
															 CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS SIGNED) AS DECIMAL)/10000.0 AS TA
														FROM battings AS BAT
													   WHERE BAT.player_id = "' + eachPlayer.player_id + '" AND
															 BAT.game_id IN (SELECT * FROM
																				(SELECT BAT.game_id
																			       FROM battings AS BAT,
																					    games AS G,
																					    cups AS C
																				  WHERE BAT.game_id = G.game_id AND
																						G.cup_id = C.cup_id AND
																						C.year = ' + @year.to_s + ' AND
																						player_id = "' + eachPlayer.player_id + '"
																			   ORDER BY BAT.game_id DESC
																				  LIMIT ' + @top.to_s + ')
																			 AS t) AND
															 				(SELECT COUNT(*)
																			   FROM battings AS BAT,
																					games AS G,
																					cups AS C
																			  WHERE BAT.game_id = G.game_id AND
																					G.cup_id = C.cup_id AND
																					C.year = ' + @year.to_s + ' AND
																					player_id = "' + eachPlayer.player_id + '") >= ' + @top.to_s)[0]
				
				if @playerBatting.PA == nil
					@HashPlayerBatting[eachPlayer.player_id] = Struct::PlayerBatting.new(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
				else
					@HashPlayerBatting[eachPlayer.player_id] = Struct::PlayerBatting.new(@playerBatting.PA,
																						 @playerBatting.AB,
																						 @playerBatting.H,
																						 @playerBatting.B2,
																						 @playerBatting.B3,
																						 @playerBatting.HR,
																						 @playerBatting.TB,
																						 @playerBatting.RBI,
																						 @playerBatting.R,
																						 @playerBatting.SO,
																						 @playerBatting.BB,
																						 @playerBatting.IBB,
																						 @playerBatting.SF,
																						 @playerBatting.E,
																						 @playerBatting.AVG,
																						 @playerBatting.OBP,
																						 @playerBatting.SLG,
																						 @playerBatting.OPS,
																						 @playerBatting.TA)
				end
				
				@playerFielding = Fielding.find_by_sql('SELECT SUM(FIELD.InnOuts)/3 AS INN,
															   SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E) AS TC,
															   SUM(FIELD.PO) AS PO,
															   SUM(FIELD.A) AS A,
															   SUM(FIELD.E) AS E,
															   CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.A)+SUM(FIELD.E)+0.000000000000000000000000000000000000001)*10000 AS SIGNED) AS DECIMAL)/10000 AS FPCT
														  FROM fieldings AS FIELD
														 WHERE FIELD.player_id = "' + eachPlayer.player_id + '" AND
															   FIELD.POS <> "C" AND
															   FIELD.game_id IN (SELECT * FROM
																					(SELECT FIELD.game_id
																					   FROM fieldings AS FIELD,
																							games AS G,
																							cups AS C
																					  WHERE FIELD.game_id = G.game_id AND
																							G.cup_id = C.cup_id AND
																							C.year = ' + @year.to_s + ' AND
																							player_id = "' + eachPlayer.player_id + '"
																				   ORDER BY FIELD.game_id DESC
																					  LIMIT ' + @top.to_s + ') AS t)AND
																				(SELECT COUNT(*)
																				   FROM fieldings AS FIELD,
																						games AS G,
																						cups AS C
																				  WHERE FIELD.game_id = G.game_id AND
																						G.cup_id = C.cup_id AND
																						C.year = ' + @year.to_s + ' AND
																						player_id = "' + eachPlayer.player_id + '") >= ' + @top.to_s)[0]
				if @playerFielding.TC == nil
					@HashPlayerFielding[eachPlayer.player_id] = Struct::PlayerFielding.new(0.0, 0, 0, 0, 0, 0.0)
				else
					@HashPlayerFielding[eachPlayer.player_id] = Struct::PlayerFielding.new(@playerFielding.INN,
																						   @playerFielding.TC,
																						   @playerFielding.PO,
																						   @playerFielding.A,
																						   @playerFielding.E,
																						   @playerFielding.FPCT)
				end
			end
			
			@HashPlayerBatting = @HashPlayerBatting.sort_by {|k,v| [v.AVG,v.H]}.reverse.to_h
			@HashPlayerFielding = @HashPlayerFielding.sort_by {|k,v| [v.FPCT,v.TC]}.reverse.to_h
			
		else
			session[:previous_url] = request.fullpath
			redirect_to :action => 'new', :controller => 'sessions'
		end
	end
	
end
