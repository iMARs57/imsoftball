class RecordsController < ApplicationController
	def index
	
		if logged_in?

			
			
			
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
														 teamHomeID = G.home_team_id AND
														 teamAwayID = G.away_team_id AND
														 G.game_id = "' + @game_id + '"')[0]
				@game_BattingAway = Batting.find_by_sql('SELECT BAT.team_id,
																BAT."order",
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
																CAST(CAST((BAT.H/(BAT.AB+0.0000000000000000000000000000000000001)*1000) AS INTEGER) AS REAL)/1000.0 AS AVG
														   FROM battings AS BAT 
														  WHERE BAT.game_id = "' + @game_id + '" AND
																BAT.team_id = "' + @game_onegame.teamAwayID + '"
													   ORDER BY BAT."order"')
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
																   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*1000) AS INTEGER) AS REAL)/1000.0 AS AVG
															  FROM battings AS BAT
															 WHERE BAT.game_id = "' + @game_id + '" AND
																   BAT.team_id = "' + @game_onegame.teamAwayID + '"')[0]
				@game_BattingHome = Batting.find_by_sql('SELECT BAT.team_id,
																BAT."order",
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
																CAST(CAST((BAT.H/(BAT.AB+0.0000000000000000000000000000000000001)*1000) AS INTEGER) AS REAL)/1000.0 AS AVG
														   FROM battings AS BAT 
														  WHERE BAT.game_id = "' + @game_id + '" AND
																BAT.team_id = "' + @game_onegame.teamHomeID + '"
													   ORDER BY BAT."order"')
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
																   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*1000) AS INTEGER) AS REAL)/1000.0 AS AVG
															  FROM battings AS BAT
															 WHERE BAT.game_id = "' + @game_id + '" AND
																   BAT.team_id = "' + @game_onegame.teamHomeID + '"')[0]
				@game_PitchingAway = Pitching.find_by_sql('SELECT PIT.team_id,
																  PIT.player_id,
																  CAST(PIT.IPouts/3.0*10 AS REAL)/10 AS IP,
																  PIT.BAOpp,
																  PIT.H,
																  PIT.HR,
																  PIT.SO,
																  PIT.BB,
																  PIT.IBB,
																  PIT.R,
																  PIT.ER,
																  CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*100 AS INTEGER) AS REAL)/100.0 AS ERA5,
																  CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*100 AS INTEGER) AS REAL)/100.0 AS ERA7,
																  PIT.W,
																  PIT.L,
																  PIT.SV
															 FROM pitchings AS PIT 
															WHERE PIT.game_id = "' + @game_id + '" AND
																  PIT.team_id = "' + @game_onegame.teamAwayID + '"
														 ORDER BY PIT."order"')
				@game_AllPitchingAway = Pitching.find_by_sql('SELECT PIT.team_id,
																	 CAST(SUM(PIT.IPouts)/3.0*10 AS REAL)/10 AS IP,
																	 SUM(PIT.BAOpp) AS BAOpp,
																	 SUM(PIT.H) AS H,
																	 SUM(PIT.HR) AS HR,
																	 SUM(PIT.SO) AS SO,
																	 SUM(PIT.BB) AS BB,
																	 SUM(PIT.IBB) AS IBB,
																	 SUM(PIT.R) AS R,
																	 SUM(PIT.ER) AS ER,
																	 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*100 AS INTEGER) AS REAL)/100.0 AS ERA5,
																	 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*100 AS INTEGER) AS REAL)/100.0 AS ERA7
																FROM pitchings AS PIT
															   WHERE PIT.game_id = "' + @game_id + '" AND
																	 PIT.team_id = "' + @game_onegame.teamAwayID + '"')[0]
				@game_PitchingHome = Pitching.find_by_sql('SELECT PIT.team_id,
																  PIT.player_id,
																  CAST(PIT.IPouts/3.0*10 AS REAL)/10 AS IP,
																  PIT.BAOpp,
																  PIT.H,
																  PIT.HR,
																  PIT.SO,
																  PIT.BB,
																  PIT.IBB,
																  PIT.R,
																  PIT.ER,
																  CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*100 AS INTEGER) AS REAL)/100.0 AS ERA5,
																  CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*100 AS INTEGER) AS REAL)/100.0 AS ERA7,
																  PIT.W,
																  PIT.L,
																  PIT.SV
															 FROM pitchings AS PIT 
															WHERE PIT.game_id = "' + @game_id + '" AND
																  PIT.team_id = "' + @game_onegame.teamHomeID + '"
														 ORDER BY PIT."order"')
				@game_AllPitchingHome = Pitching.find_by_sql('SELECT PIT.team_id,
																	 CAST(SUM(PIT.IPouts)/3.0*10 AS REAL)/10 AS IP,
																	 SUM(PIT.BAOpp) AS BAOpp,
																	 SUM(PIT.H) AS H,
																	 SUM(PIT.HR) AS HR,
																	 SUM(PIT.SO) AS SO,
																	 SUM(PIT.BB) AS BB,
																	 SUM(PIT.IBB) AS IBB,
																	 SUM(PIT.R) AS R,
																	 SUM(PIT.ER) AS ER,
																	 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*100 AS INTEGER) AS REAL)/100.0 AS ERA5,
																	 CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*100 AS INTEGER) AS REAL)/100.0 AS ERA7
																FROM pitchings AS PIT
															   WHERE PIT.game_id = "' + @game_id + '" AND
																	 PIT.team_id = "' + @game_onegame.teamHomeID + '"')[0]
				@game_FieldingAway = Fielding.find_by_sql('SELECT FIELD.team_id,
																  FIELD.POS,
																  FIELD.player_id,
																  CAST(FIELD.InnOuts/3.0*10 AS REAL)/10 AS INN,
																  FIELD.PO+FIELD.K+FIELD.A+FIELD.E AS TC,
																  FIELD.PO,
																  FIELD.K,
																  FIELD.A,
																  FIELD.E,
																  CAST(CAST((FIELD.PO+FIELD.K+FIELD.A)/(FIELD.PO+FIELD.K+FIELD.A+FIELD.E+0.000000000000000000000000000001)*1000 AS INTEGER) AS REAL)/1000.0 AS FPCT
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
																	 CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A)+SUM(FIELD.E)+0.00000000000000000000000000000000001)*1000 AS INTEGER) AS REAL)/1000.0 AS FPCT
																FROM fieldings AS FIELD
															   WHERE FIELD.game_id = "' + @game_id + '" AND
																	 FIELD.team_id = "' + @game_onegame.teamAwayID + '"')[0]
				@game_FieldingHome = Fielding.find_by_sql('SELECT FIELD.team_id,
																  FIELD.POS,
																  FIELD.player_id,
																  CAST(FIELD.InnOuts/3.0*10 AS REAL)/10 AS INN,
																  FIELD.PO+FIELD.K+FIELD.A+FIELD.E AS TC,
																  FIELD.PO,
																  FIELD.K,
																  FIELD.A,
																  FIELD.E,
																  CAST(CAST((FIELD.PO+FIELD.K+FIELD.A)/(FIELD.PO+FIELD.K+FIELD.A+FIELD.E+0.000000000000000000000000000001)*1000 AS INTEGER) AS REAL)/1000.0 AS FPCT
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
																	 CAST(CAST((SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A))/(SUM(FIELD.PO)+SUM(FIELD.K)+SUM(FIELD.A)+SUM(FIELD.E)+0.00000000000000000000000000000000001)*1000 AS INTEGER) AS REAL)/1000.0 AS FPCT
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
			
			@sql_year = ''
			# 別頁傳入cup參數導入此頁時會用到
			if @year != nil && @year != 'Wildcard' && @cup == nil # 年份不是選不分年度且盃賽為空
				@sql_year = 'AND BAT.game_id IN (SELECT DISTINCT G.game_id
												   FROM battings AS BAT,
														games AS G, 
														cups AS C
												  WHERE BAT.game_id = G.game_id AND
														G.cup_id = C.cup_id AND
														C.year = ' + @year.to_s + ')'
			elsif @year == 'Wildcard' && @cup != nil # 年份選不分年度且盃賽不為空
				@sql_year = 'AND BAT.game_id IN (SELECT DISTINCT G.game_id
												   FROM battings AS BAT,
														games AS G, 
														cups AS C
												  WHERE BAT.game_id = G.game_id AND
														G.cup_id = C.cup_id AND
														C.cup_name = "' + @cup + '")'
			elsif @year != nil && @cup != nil # 年份非空且盃賽非空
				if @cup == '官方賽'
					@sql_year = 'AND BAT.game_id IN (SELECT DISTINCT G.game_id
												   FROM battings AS BAT,
														games AS G, 
														cups AS C
												  WHERE BAT.game_id = G.game_id AND
														G.cup_id = C.cup_id AND
														C.year = ' + @year.to_s + ' AND
														C.official = 1)'
				elsif @cup == '正式賽'
					@sql_year = 'AND BAT.game_id IN (SELECT DISTINCT G.game_id
												   FROM battings AS BAT,
														games AS G, 
														cups AS C
												  WHERE BAT.game_id = G.game_id AND
														G.cup_id = C.cup_id AND
														C.year = ' + @year.to_s + ' AND
														C.formal = 1)'
				elsif @cup == '聯盟賽'
					@sql_year = 'AND BAT.game_id IN (SELECT DISTINCT G.game_id
												   FROM battings AS BAT,
														games AS G, 
														cups AS C
												  WHERE BAT.game_id = G.game_id AND
														G.cup_id = C.cup_id AND
														C.year = ' + @year.to_s + ' AND
														C.cup_name = "台大聯盟")'
				else
					@sql_year = 'AND BAT.game_id IN (SELECT DISTINCT G.game_id
												   FROM battings AS BAT,
														games AS G, 
														cups AS C
												  WHERE BAT.game_id = G.game_id AND
														G.cup_id = C.cup_id AND
														C.year = ' + @year.to_s + ' AND
														C.cup_name = "' + @cup + '")'
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
					@sql_year = ''
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
														  CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
														  CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS OBP,
														  CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS SLG,
														  (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) AS OPS,
														  CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS TA
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
																   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
																   CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS OBP,
																   CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS SLG,
																   (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) AS OPS,
																   CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS TA
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
																    CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
																    CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS OBP,
																    CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS SLG,
																    (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) AS OPS,
																    CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS TA
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
																     CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
																     CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS OBP,
																     CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS SLG,
																     (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) AS OPS,
																     CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS TA
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
															   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS OBP,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS SLG,
															   (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) AS OPS,
															   CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS TA,
													           (CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0)*1000+SUM(BAT.HR)*20+SUM(BAT.RBI)*5+(SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3) AS SILVER
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
															   CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS OBP,
															   CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS SLG,
															   (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) AS OPS,
															   CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS TA,
													           (CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0)*1000+SUM(BAT.HR)*20+SUM(BAT.RBI)*5+(SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3) AS SILVER
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
																    CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
																    CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS OBP,
																    CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS SLG,
																    (CAST(CAST(((SUM(BAT.H)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) + (CAST(CAST(((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) AS OPS,
																    CAST(CAST((((SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3)+SUM(BAT.BB)+SUM(BAT.IBB))/(SUM(BAT.AB)-SUM(BAT.H)+SUM(BAT.GIDP)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS TA,
																    (CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0)*1000+SUM(BAT.HR)*20+SUM(BAT.RBI)*5+(SUM(BAT.H)+SUM(BAT.B2)*1+SUM(BAT.B3)*2+SUM(BAT.HR)*3) AS SILVER
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
																	 CAST(CAST((BAT.H/(BAT.AB+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
																     CAST(CAST(((BAT.H+BAT.BB+BAT.IBB)/(BAT.AB+BAT.BB+BAT.IBB+BAT.SF+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS OBP,
																     CAST(CAST(((BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3)/(BAT.AB+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS SLG,
																     (CAST(CAST(((BAT.H+BAT.BB+BAT.IBB)/(BAT.AB+BAT.BB+BAT.IBB+BAT.SF+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) + (CAST(CAST(((BAT.H+BAT.B2*1+BAT.B3*2+BAT.HR*3)/(BAT.AB+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0) AS OPS
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
			@sql_year = ''
			
			if @year != nil && @year != 'Wildcard'
				@sql_year = ' AND PIT.game_id IN (SELECT G.game_id 
												    FROM pitchings AS PIT,
														 games AS G,
														 cups AS C
												   WHERE PIT.game_id = G.game_id AND
														 G.cup_id = C.cup_id AND
														 C.year = ' + @year.to_s + ') '
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
															CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
															(SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
															CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS INTEGER) AS REAL)/1000.0 AS ERA5,
															CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS INTEGER) AS REAL)/1000.0 AS ERA7,
															CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS INTEGER) AS REAL)/1000.0 AS R5,
															CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS INTEGER) AS REAL)/1000.0 AS R7
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
																	CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
																	(SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
																	CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS INTEGER) AS REAL)/1000.0 AS ERA5,
																	CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS INTEGER) AS REAL)/1000.0 AS ERA7,
																	CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS INTEGER) AS REAL)/1000.0 AS R5,
																	CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS INTEGER) AS REAL)/1000.0 AS R7
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
															CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
															(SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
															CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS INTEGER) AS REAL)/1000.0 AS ERA5,
															CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS INTEGER) AS REAL)/1000.0 AS ERA7,
															CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS INTEGER) AS REAL)/1000.0 AS R5,
															CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS INTEGER) AS REAL)/1000.0 AS R7 
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
					@sql_year = ''
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
																		   CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
																		   (SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
																		   CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS INTEGER) AS REAL)/1000.0 AS ERA5,
																		   CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS INTEGER) AS REAL)/1000.0 AS ERA7,
																		   CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS INTEGER) AS REAL)/1000.0 AS R5,
																		   CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS INTEGER) AS REAL)/1000.0 AS R7
																	  FROM pitchings AS PIT, 
																		   games AS G,
																		   cups AS C 
																	 WHERE PIT.player_id = "' + @player + '" AND
																		   PIT.game_id = G.game_id AND
																		   G.cup_id = C.cup_id
																  GROUP BY C.year')
				else
					@sql_year = ' AND PIT.game_id IN (SELECT G.game_id 
														FROM pitchings AS PIT,
															 games AS G,
															 cups AS C
													   WHERE PIT.game_id = G.game_id AND
															 G.cup_id = C.cup_id AND
															 C.year = ' + @year.to_s + ') '
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
																	  CAST(CAST((SUM(PIT.H)/(SUM(PIT.BAOpp)-SUM(PIT.BB)-SUM(PIT.IBB)+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
																	  (SUM(PIT.H)+SUM(PIT.BB)+SUM(PIT.IBB)+0.0)/(SUM(PIT.IPouts)+0.0000000000000000000000000000000000001)*3 AS WHIP,
																	  CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS INTEGER) AS REAL)/1000.0 AS ERA5,
																	  CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS INTEGER) AS REAL)/1000.0 AS ERA7,
																	  CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS INTEGER) AS REAL)/1000.0 AS R5,
																	  CAST(CAST(SUM(PIT.R)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS INTEGER) AS REAL)/1000.0 AS R7
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
																	   CAST(CAST((PIT.H/(PIT.BAOpp-PIT.BB-PIT.IBB+0.0000000000000000000000000000000000001)*10000) AS INTEGER) AS REAL)/10000.0 AS AVG,
																	   (PIT.H+PIT.BB+PIT.IBB+0.0)/(PIT.IPouts+0.0000000000000000000000000000000000001)*3 AS WHIP,
																	   CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS INTEGER) AS REAL)/1000.0 AS ERA5,
																	   CAST(CAST(PIT.ER/(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS INTEGER) AS REAL)/1000.0 AS ERA7,
																	   CAST(CAST(PIT.R/(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*1000 AS INTEGER) AS REAL)/1000.0 AS R5,
																	   CAST(CAST(PIT.R/(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*1000 AS INTEGER) AS REAL)/1000.0 AS R7
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
	
end
