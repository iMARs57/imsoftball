class HomeController < ApplicationController

	require "ipaddr"

	def remote_ip
		locIp = IPAddr.new("127.0.0.1")
		remIP = IPAddr.new(request.remote_ip)
		if remIP === locIp || remIP === IPAddr.new("::1")
			# Hard coded remote address for test
			#IPAddr.new("123.45.67.89")
			return IPAddr.new("140.112.12.34")
		else
			return remIP
		end
	end
	
	def memberQuery(age)
		@query = Member.select('members.*')
                       .where('members.IM_age = ' + age.to_s)
                       .order('number')
		return @query
	end
	
	def memberQuery_active(age)
		@query = Member.select('members.*')
                       .where('members.IM_age = ' + age.to_s)
					   .where('members.active = 1')
                       .order('number')
		return @query
	end
	
	def memberQuery_leadership(age, type)
		@query = Member.select('members.*')
                       .where('members.IM_age = ' + age.to_s)
					   .where('members.leadership = ' + type.to_s)
                       .order('number')
		return @query
	end
	

  def index  
    
	ntuIP = IPAddr.new("140.112.0.0/16")
    if (ntuIP === remote_ip) || logged_in?
	
	  # 執行秀出已授權可看的畫面內容
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
          @academicYear = (Time.now.year - 1911).to_s
          @thisyear = Time.now.year
        else
          @academicYear = (Time.now.year - 1912).to_s
          @thisyear = Time.now.year - 1
        end
      end
	  
      # News' kaminari setup
      @informations = Information.order('date DESC').page(params[:page]).per(10)
      # SQL for Info Board
      @panel_allGames = Game.select('games.*,
                                     cups.cup_name,
                                     teamAway.team_name AS teamAway_name,
                                     teamHome.team_name AS teamHome_name')
                            .joins('INNER JOIN cups ON cups.cup_id = games.cup_id')
                            .joins('INNER JOIN teams AS teamAway ON games.away_team_id = teamAway.team_id')
                            .joins('INNER JOIN teams AS teamHome ON games.home_team_id = teamHome.team_id')
                            .order('game_id DESC').take(5)
      @panel_formalGames = Game.select('games.*,
                                        cups.cup_name,
                                        teamAway.team_name AS teamAway_name,
                                        teamHome.team_name AS teamHome_name')
                               .where('cups.formal = "1"')
                               .joins('INNER JOIN cups ON cups.cup_id = games.cup_id')
                               .joins('INNER JOIN teams AS teamAway ON games.away_team_id = teamAway.team_id')
                               .joins('INNER JOIN teams AS teamHome ON games.home_team_id = teamHome.team_id')
                               .order('game_id DESC').take(5)
      @panel_officialGames = Game.select('games.*,
                                          cups.cup_name,
                                          teamAway.team_name AS teamAway_name,
                                          teamHome.team_name AS teamHome_name')
                                 .where('cups.official = "1"')
                                 .joins('INNER JOIN cups ON cups.cup_id = games.cup_id')
                                 .joins('INNER JOIN teams AS teamAway ON games.away_team_id = teamAway.team_id')
                                 .joins('INNER JOIN teams AS teamHome ON games.home_team_id = teamHome.team_id')
                                 .order('game_id DESC').take(5)
      @panel_leagueGames = Game.select('games.*,
                                        cups.cup_name,
                                        teamAway.team_name AS teamAway_name,
                                        teamHome.team_name AS teamHome_name')
                               .where('cups.cup_name = "台大聯盟"')
                               .joins('INNER JOIN cups ON cups.cup_id = games.cup_id')
                               .joins('INNER JOIN teams AS teamAway ON games.away_team_id = teamAway.team_id')
                               .joins('INNER JOIN teams AS teamHome ON games.home_team_id = teamHome.team_id')
                               .order('game_id DESC').take(5)
      @panel_friendlyGames = Game.select('games.*,
                                          cups.cup_name,
                                          teamAway.team_name AS teamAway_name,
                                          teamHome.team_name AS teamHome_name')
                                 .where('cups.formal = "0" AND cups.official = "0"')
                                 .joins('INNER JOIN cups ON cups.cup_id = games.cup_id')
                                 .joins('INNER JOIN teams AS teamAway ON games.away_team_id = teamAway.team_id')
                                 .joins('INNER JOIN teams AS teamHome ON games.home_team_id = teamHome.team_id')
                                 .order('game_id DESC').take(5)
      @panel_standings_GP = Game.where('games.game_id LIKE "' + @academicYear + '__" 
                                   AND (games.home_team_id = "IM" OR 
                                        games.away_team_id = "IM" OR
                                       (games.home_team_id = "IM-A" AND games.away_team_id <> "IM-B") OR
                                       (games.home_team_id = "IM-B" AND games.away_team_id <> "IM-A") OR
                                       (games.away_team_id = "IM-A" AND games.home_team_id <> "IM-B") OR
                                       (games.away_team_id = "IM-B" AND games.home_team_id <> "IM-A"))')
                                .count('games.game_id')
      @panel_standings_W = Game.where('games.game_id LIKE "' + @academicYear + '__" 
                                   AND (games.home_team_id = "IM" OR games.away_team_id = "IM" OR
                                       (games.home_team_id = "IM-A" AND games.away_team_id <> "IM-B") OR
                                       (games.home_team_id = "IM-B" AND games.away_team_id <> "IM-A") OR
                                       (games.away_team_id = "IM-A" AND games.home_team_id <> "IM-B") OR
                                       (games.away_team_id = "IM-B" AND games.home_team_id <> "IM-A"))
                                   AND ((games.home_score > games.away_score AND games.home_team_id = "IM") OR 
                                        (games.home_score < games.away_score AND games.away_team_id = "IM") OR
                                        (games.home_score > games.away_score AND games.home_team_id = "IM-A") OR
                                        (games.home_score < games.away_score AND games.away_team_id = "IM-A") OR
                                        (games.home_score > games.away_score AND games.home_team_id = "IM-B") OR 
                                        (games.home_score < games.away_score AND games.away_team_id = "IM-B"))')
                               .count('games.game_id')
      @panel_standings_L = Game.where('games.game_id LIKE "' + @academicYear + '__" 
                                   AND (games.home_team_id = "IM" OR games.away_team_id = "IM" OR
                                       (games.home_team_id = "IM-A" AND games.away_team_id <> "IM-B") OR
                                       (games.home_team_id = "IM-B" AND games.away_team_id <> "IM-A") OR
                                       (games.away_team_id = "IM-A" AND games.home_team_id <> "IM-B") OR
                                       (games.away_team_id = "IM-B" AND games.home_team_id <> "IM-A"))
                                   AND ((games.home_score < games.away_score AND games.home_team_id = "IM") OR 
                                        (games.home_score > games.away_score AND games.away_team_id = "IM") OR
                                        (games.home_score < games.away_score AND games.home_team_id = "IM-A") OR
                                        (games.home_score > games.away_score AND games.away_team_id = "IM-A") OR
                                        (games.home_score < games.away_score AND games.home_team_id = "IM-B") OR 
                                        (games.home_score > games.away_score AND games.away_team_id = "IM-B"))')
                               .count('games.game_id')
      @panel_standings_D = Game.where('games.game_id LIKE "' + @academicYear + '__" 
                                   AND (games.home_team_id = "IM" OR games.away_team_id = "IM" OR
                                       (games.home_team_id = "IM-A" AND games.away_team_id <> "IM-B") OR
                                       (games.home_team_id = "IM-B" AND games.away_team_id <> "IM-A") OR
                                       (games.away_team_id = "IM-A" AND games.home_team_id <> "IM-B") OR
                                       (games.away_team_id = "IM-B" AND games.home_team_id <> "IM-A"))
                                   AND ((games.home_score = games.away_score AND games.home_team_id = "IM") OR 
                                        (games.home_score = games.away_score AND games.away_team_id = "IM") OR
                                        (games.home_score = games.away_score AND games.home_team_id = "IM-A") OR
                                        (games.home_score = games.away_score AND games.away_team_id = "IM-A") OR
                                        (games.home_score = games.away_score AND games.home_team_id = "IM-B") OR 
                                        (games.home_score = games.away_score AND games.away_team_id = "IM-B"))')
                               .count('games.game_id')
      @panel_standings_WLD = Game.where('games.game_id LIKE "' + @academicYear + '__" 
                                    AND (games.home_team_id = "IM" OR 
                                         games.away_team_id = "IM" OR
                                        (games.home_team_id = "IM-A" AND games.away_team_id <> "IM-B") OR
                                        (games.home_team_id = "IM-B" AND games.away_team_id <> "IM-A") OR
                                        (games.away_team_id = "IM-A" AND games.home_team_id <> "IM-B") OR
                                        (games.away_team_id = "IM-B" AND games.home_team_id <> "IM-A"))')
      @counter = 0;
      @panel_standings_last10_W = 0
      @panel_standings_last10_L = 0
      @panel_standings_last10_D = 0
      @panel_standings_away_W = 0;
      @panel_standings_away_L = 0;
      @panel_standings_away_D = 0;
      @panel_standings_home_W = 0;
      @panel_standings_home_L = 0;
      @panel_standings_home_D = 0;
      
      @panel_standings_WLD.each do |wld|
        if wld.home_team_id == "IM" || wld.home_team_id == "IM-A" || wld.home_team_id == "IM-B"
          if wld.home_score > wld.away_score
            @panel_standings_home_W = @panel_standings_home_W + 1;
            if @counter < 10
              @panel_standings_last10_W = @panel_standings_last10_W + 1;
            end
          elsif wld.home_score < wld.away_score
            @panel_standings_home_L = @panel_standings_home_L + 1;
            if @counter < 10  
              @panel_standings_last10_L = @panel_standings_last10_L + 1;
            end
          else
            @panel_standings_home_D = @panel_standings_home_D + 1;
            if @counter < 10
              @panel_standings_last10_D = @panel_standings_last10_D + 1;
            end
          end
        else
          if wld.home_score < wld.away_score
            @panel_standings_away_W = @panel_standings_away_W + 1;
            if @counter < 10
              @panel_standings_last10_W = @panel_standings_last10_W + 1;
            end
          elsif wld.home_score > wld.away_score 
            @panel_standings_away_L = @panel_standings_away_L + 1;
            if @counter < 10
              @panel_standings_last10_L = @panel_standings_last10_L + 1;
            end
          else
            @panel_standings_away_D = @panel_standings_away_D + 1;
            if @counter < 10
              @panel_standings_last10_D = @panel_standings_last10_D + 1;
            end
          end
        end
        @counter = @counter + 1;
      end

      @panel_standings_forAvgBat = Game.find_by_sql('SELECT SUM(b.AB) AS allAB, SUM(b.H) AS allH, SUM(b.HR) AS allHR
                                                     FROM games AS g, battings AS b
                                                     WHERE g.game_id LIKE "' + @academicYear + '__"
                                                     AND (g.home_team_id = "IM" OR 
                                                          g.away_team_id = "IM" OR
                                                         (g.home_team_id = "IM-A" AND g.away_team_id <> "IM-B") OR
                                                         (g.home_team_id = "IM-B" AND g.away_team_id <> "IM-A") OR
                                                         (g.away_team_id = "IM-A" AND g.home_team_id <> "IM-B") OR
                                                         (g.away_team_id = "IM-B" AND g.home_team_id <> "IM-A"))
                                                     AND g.game_id = b.game_id
                                                     AND (b.team_id = "IM" OR
                                                          b.team_id = "IM-A" OR
                                                          b.team_id = "IM-B")')[0]
      @panel_standings_forAvgDef = Game.find_by_sql('SELECT SUM(f.PO) AS allPO, SUM(f.A) AS allA, SUM(f.E) AS allE
                                                     FROM games AS g, fieldings AS f
                                                     WHERE g.game_id LIKE "' + @academicYear + '__"
                                                     AND (g.home_team_id = "IM" OR 
                                                          g.away_team_id = "IM" OR
                                                         (g.home_team_id = "IM-A" AND g.away_team_id <> "IM-B") OR
                                                         (g.home_team_id = "IM-B" AND g.away_team_id <> "IM-A") OR
                                                         (g.away_team_id = "IM-A" AND g.home_team_id <> "IM-B") OR
                                                         (g.away_team_id = "IM-B" AND g.home_team_id <> "IM-A"))
                                                     AND g.game_id = f.game_id
                                                     AND (f.team_id = "IM" OR
                                                          f.team_id = "IM-A" OR
                                                          f.team_id = "IM-B")')[0]
      @panel_standings_forAvgERA = Game.find_by_sql('SELECT SUM(p.IPouts) AS allIPouts, SUM(p.ER) AS allER
                                                     FROM games AS g, pitchings AS p
                                                     WHERE g.game_id LIKE "' + @academicYear + '__"
                                                     AND (g.home_team_id = "IM" OR 
                                                          g.away_team_id = "IM" OR
                                                         (g.home_team_id = "IM-A" AND g.away_team_id <> "IM-B") OR
                                                         (g.home_team_id = "IM-B" AND g.away_team_id <> "IM-A") OR
                                                         (g.away_team_id = "IM-A" AND g.home_team_id <> "IM-B") OR
                                                         (g.away_team_id = "IM-B" AND g.home_team_id <> "IM-A"))
                                                     AND g.game_id = p.game_id
                                                     AND (p.team_id = "IM" OR
                                                          p.team_id = "IM-A" OR
                                                          p.team_id = "IM-B")')[0]
      @panel_standings_AvgERA5 = '%.2f' % (15.0 * @panel_standings_forAvgERA.allER.to_f / @panel_standings_forAvgERA.allIPouts.to_f)
      @panel_standings_AvgERA7 = '%.2f' % (21.0 * @panel_standings_forAvgERA.allER.to_f / @panel_standings_forAvgERA.allIPouts.to_f)

      
      # Top 5 panel

      @activePLAYER = 150
      @gameNumber = Game.where('cups.year = ' + @thisyear.to_s).joins('INNER JOIN cups ON cups.cup_id = games.cup_id').count()
      @bat_year = "AND BAT.game_id IN 
                   (SELECT G.game_id 
                    FROM battings AS BAT, games AS G, cups AS C 
                    WHERE BAT.game_id = G.game_id AND G.cup_id = C.cup_id AND C.year = " + @thisyear.to_s + " )";
      @pitch_year = "AND PIT.game_id IN 
                     (SELECT G.game_id 
                      FROM pitchings AS PIT, games AS G, cups AS C 
                      WHERE PIT.game_id = G.game_id and G.cup_id = C.cup_id and C.year = " + @thisyear.to_s + " )";

      @panel_top5_AVG = Batting.find_by_sql('WITH Top5AVG(Batter,fName,lName,AVG,ABs,Hits,RBIs) 
                                                      AS (SELECT BAT.player_id AS "Batter",
                                                                 PLY.player_fname AS "fName",
                                                                 PLY.player_lname AS "lName",
                                                                 CAST(CAST((SUM(BAT."H")/(SUM(BAT."AB")+0.0000000000000000000000000000000000001)*1000) AS INTEGER) AS REAL)/1000.0 AS "AVG",
                                                                 SUM(BAT."AB") AS "ABs",
                                                                 SUM(BAT."H") AS "Hits",
                                                                 SUM(BAT."RBI") AS "RBIs"
                                                          FROM battings AS BAT, 
                                                               players AS PLY
                                                          WHERE BAT.player_id = PLY.player_id AND 
                                                                PLY.member = 1 ' +
                                                                @bat_year +
                                                        ' GROUP BY BAT.player_id,
                                                                   PLY.player_fname,
                                                                   PLY.player_lname 
                                                          HAVING (SUM(BAT."AB")+SUM(BAT."BB")+SUM(BAT."IBB")+SUM(BAT."SF") >= ' + @gameNumber.to_s + ' OR
                                                                  SUM(BAT."AB")+SUM(BAT."BB")+SUM(BAT."IBB")+SUM(BAT."SF") >= ' + @activePLAYER.to_s + ' ) 
                                                          ORDER BY "AVG" DESC, 
                                                                   "Hits" DESC, 
                                                                   "RBIs" DESC)
                                             SELECT "QueryAVG".Batter AS "ID",
                                                    "QueryAVG".AVG AS "Data",
                                                    "QueryAVG".fName AS "firstName",
                                                    "QueryAVG".lName AS "lastName",
                                                    COUNT(QueryAVG2."AVG")+1 AS "Rank"
                                                    FROM Top5AVG "QueryAVG"
                                                    LEFT JOIN Top5AVG "QueryAVG2"
                                                    ON "QueryAVG".AVG < "QueryAVG2".AVG
                                                    GROUP BY QueryAVG.Batter,
                                                             QueryAVG.AVG
                                                    HAVING Rank IN 
                                                        (SELECT COUNT(QueryAVG2."AVG")+1 AS "avgRank"
                                                           FROM Top5AVG AS QueryAVG
                                                      LEFT JOIN Top5AVG AS QueryAVG2 ON QueryAVG.AVG < QueryAVG2.AVG
                                                       GROUP BY QueryAVG.Batter,
                                                                QueryAVG.AVG
                                                       ORDER BY "avgRank" ASC
                                                          LIMIT 5)
                                                    ORDER BY "Rank" ASC')
      @panel_top5_AVGS = Batting.find_by_sql('WITH Top5AVGS(Batter,fName,lName,AVG,ABs,Hits,BBs,IBBs,SFs,AVGS,RBIs) 
                                                      AS (SELECT BAT.player_id AS Batter,
                                                                 PLY.player_fname AS fName,
                                                                 PLY.player_lname AS lName,
                                                                 CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*1000) AS INTEGER) AS REAL)/1000.0 AS AVG,
                                                                 SUM(BAT.AB) AS ABs,
                                                                 SUM(BAT.H) AS Hits,
                                                                 SUM(BAT.BB) AS BBs,
                                                                 SUM(BAT.IBB) AS IBBs,
                                                                 SUM(BAT.SF) AS SFs,
                                                                 CASE WHEN ((SUM(BAT.AB) + SUM(BAT.BB) + SUM(BAT.IBB) + SUM(BAT.SF)) > ' + @gameNumber.to_s + ') OR 
                                                                           ((SUM(BAT.AB) + SUM(BAT.BB) + SUM(BAT.IBB) + SUM(BAT.SF)) > ' + @activePLAYER.to_s + ')
                                                                          THEN CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+0.0000000000000000000000000000000000001)*1000) AS INTEGER) AS REAL)/1000.0
                                                                      ELSE CAST(CAST((SUM(BAT.H)/(SUM(BAT.AB)+(' + [@gameNumber, @activePLAYER].min.to_s + ' - (SUM(BAT.AB) + SUM(BAT.BB) + SUM(BAT.IBB) + SUM(BAT.SF)))+0.0000000000000000000000000000000000001)*1000) AS INTEGER) AS REAL)/1000.0
                                                                      END
                                                                 AS AVGS,
                                                                 SUM(BAT.RBI) AS RBIs     
                                                          FROM battings AS BAT, 
                                                               players AS PLY
                                                          WHERE BAT.player_id = PLY.player_id AND 
                                                                PLY.member = 1 ' +
                                                                @bat_year +
                                                        ' GROUP BY BAT.player_id
                                                          ORDER BY AVGS DESC, 
                                                                   Hits DESC, 
                                                                   RBIs DESC)
                                             SELECT QueryAVGS.Batter AS ID,
                                                    printf("%.3f",QueryAVGS.AVGS) || " ( " || printf("%.3f",QueryAVGS.AVG) || " )" AS Data,
                                                    QueryAVGS.fName AS firstName,
                                                    QueryAVGS.lName AS lastName,
                                                    COUNT(QueryAVGS2.AVGS)+1 AS Rank
                                                    FROM Top5AVGS AS QueryAVGS
                                                    LEFT JOIN Top5AVGS AS QueryAVGS2
                                                    ON QueryAVGS.AVGS < QueryAVGS2.AVGS
                                                    GROUP BY QueryAVGS.Batter,
                                                             QueryAVGS.AVGS
                                                    HAVING Rank IN 
                                                        (SELECT COUNT(QueryAVGS2.AVGS)+1 AS avgsRank
                                                           FROM Top5AVGS AS QueryAVGS
                                                      LEFT JOIN Top5AVGS AS QueryAVGS2 ON QueryAVGS.AVGS < QueryAVGS2.AVGS
                                                       GROUP BY QueryAVGS.Batter,
                                                                QueryAVGS.AVGS
                                                       ORDER BY avgsRank ASC
                                                          LIMIT 5)
                                                    ORDER BY Rank ASC')
      @panel_top5_H = Batting.find_by_sql('WITH Top5H(Batter,fName,lName,Hits,ABs) 
                                                      AS (SELECT BAT.player_id AS Batter,
                                                                 PLY.player_fname AS fName,
                                                                 PLY.player_lname AS lName,
                                                                 SUM(BAT.H) AS Hits,
                                                                 SUM(BAT.AB) AS ABs
                                                          FROM battings AS BAT, 
                                                               players AS PLY
                                                          WHERE BAT.player_id = PLY.player_id AND 
                                                                PLY.member = 1 ' +
                                                                @bat_year +
                                                        ' GROUP BY BAT.player_id 
                                                          HAVING SUM(BAT.H) > 0 
                                                          ORDER BY Hits DESC, 
                                                                   ABs DESC)
                                             SELECT QueryH.Batter AS ID,
                                                    QueryH.Hits AS Data,
                                                    QueryH.fName AS firstName,
                                                    QueryH.lName AS lastName,
                                                    COUNT(QueryH2.Hits)+1 AS Rank
                                                    FROM Top5H AS QueryH
                                                    LEFT JOIN Top5H AS QueryH2
                                                    ON QueryH.Hits < QueryH2.Hits
                                                    GROUP BY QueryH.Batter,
                                                             QueryH.Hits
                                                    HAVING Rank IN 
                                                        (SELECT COUNT(QueryH2.Hits)+1 AS hRank
                                                           FROM Top5H AS QueryH
                                                      LEFT JOIN Top5H AS QueryH2 ON QueryH.Hits < QueryH2.Hits
                                                       GROUP BY QueryH.Batter,
                                                                QueryH.Hits
                                                       ORDER BY hRank ASC
                                                          LIMIT 5)
                                                    ORDER BY Rank ASC')
      @panel_top5_HR = Batting.find_by_sql('WITH Top5HR(Batter,fName,lName,HRs,ABs) 
                                                      AS (SELECT BAT.player_id AS Batter,
                                                                 PLY.player_fname AS fName,
                                                                 PLY.player_lname AS lName,
                                                                 SUM(BAT.HR) AS HRs,
                                                                 SUM(BAT.AB) AS ABs
                                                          FROM battings AS BAT, 
                                                               players AS PLY
                                                          WHERE BAT.player_id = PLY.player_id AND 
                                                                PLY.member = 1 ' +
                                                                @bat_year +
                                                        ' GROUP BY BAT.player_id 
                                                          HAVING SUM(BAT.HR) > 0 
                                                          ORDER BY HRs DESC, 
                                                                   ABs,
                                                                   SUM(BAT.RBI) DESC)
                                             SELECT QueryHR.Batter AS ID,
                                                    QueryHR.HRs AS Data,
                                                    QueryHR.fName AS firstName,
                                                    QueryHR.lName AS lastName,
                                                    COUNT(QueryHR2.HRs)+1 AS Rank
                                                    FROM Top5HR AS QueryHR
                                                    LEFT JOIN Top5HR AS QueryHR2
                                                    ON QueryHR.HRs < QueryHR2.HRs
                                                    GROUP BY QueryHR.Batter,
                                                             QueryHR.HRs
                                                    HAVING Rank IN 
                                                        (SELECT COUNT(QueryHR2.HRs)+1 AS hrRank
                                                           FROM Top5HR AS QueryHR
                                                      LEFT JOIN Top5HR AS QueryHR2 ON QueryHR.HRs < QueryHR2.HRs
                                                       GROUP BY QueryHR.Batter,
                                                                QueryHR.HRs
                                                       ORDER BY hrRank ASC
                                                          LIMIT 5)
                                                    ORDER BY Rank ASC')
      @panel_top5_RBI = Batting.find_by_sql('WITH Top5RBI(Batter,fName,lName,RBIs,ABs) 
                                                      AS (SELECT BAT.player_id AS Batter,
                                                                 PLY.player_fname AS fName,
                                                                 PLY.player_lname AS lName,
                                                                 SUM(BAT.RBI) AS RBIs,
                                                                 SUM(BAT.AB) AS ABs
                                                          FROM battings AS BAT, 
                                                               players AS PLY
                                                          WHERE BAT.player_id = PLY.player_id AND 
                                                                PLY.member = 1 ' +
                                                                @bat_year +
                                                        ' GROUP BY BAT.player_id 
                                                          ORDER BY RBIs DESC, 
                                                                   SUM(BAT.H)/SUM(BAT.AB+0.00000000000000000000000000000000001) DESC,
                                                                   ABs)
                                             SELECT QueryRBI.Batter AS ID,
                                                    QueryRBI.RBIs AS Data,
                                                    QueryRBI.fName AS firstName,
                                                    QueryRBI.lName AS lastName,
                                                    COUNT(QueryRBI2.RBIs)+1 AS Rank
                                                    FROM Top5RBI AS QueryRBI
                                                    LEFT JOIN Top5RBI AS QueryRBI2
                                                    ON QueryRBI.RBIs < QueryRBI2.RBIs
                                                    GROUP BY QueryRBI.Batter,
                                                             QueryRBI.RBIs
                                                    HAVING Rank IN 
                                                        (SELECT COUNT(QueryRBI2.RBIs)+1 AS rbiRank
                                                           FROM Top5RBI AS QueryRBI
                                                      LEFT JOIN Top5RBI AS QueryRBI2 ON QueryRBI.RBIs < QueryRBI2.RBIs
                                                       GROUP BY QueryRBI.Batter,
                                                                QueryRBI.RBIs
                                                       ORDER BY rbiRank ASC
                                                          LIMIT 5)
                                                    ORDER BY Rank ASC')
      @panel_top5_R = Batting.find_by_sql('WITH Top5R(Batter,fName,lName,Rs) 
                                                      AS (SELECT BAT.player_id AS Batter,
                                                                 PLY.player_fname AS fName,
                                                                 PLY.player_lname AS lName,
                                                                 SUM(BAT.R) AS Rs
                                                          FROM battings AS BAT, 
                                                               players AS PLY
                                                          WHERE BAT.player_id = PLY.player_id AND 
                                                                PLY.member = 1 ' +
                                                                @bat_year +
                                                        ' GROUP BY BAT.player_id 
                                                          ORDER BY Rs DESC, 
                                                                   SUM(BAT.AB)+SUM(BAT.BB)+SUM(BAT.IBB)+SUM(BAT.SF))
                                             SELECT QueryR.Batter AS ID,
                                                    QueryR.Rs AS Data,
                                                    QueryR.fName AS firstName,
                                                    QueryR.lName AS lastName,
                                                    COUNT(QueryR2.Rs)+1 AS Rank
                                                    FROM Top5R AS QueryR
                                                    LEFT JOIN Top5R AS QueryR2
                                                    ON QueryR.Rs < QueryR2.Rs
                                                    GROUP BY QueryR.Batter,
                                                             QueryR.Rs
                                                    HAVING Rank IN 
                                                        (SELECT COUNT(QueryR2.Rs)+1 AS rRank
                                                           FROM Top5R AS QueryR
                                                      LEFT JOIN Top5R AS QueryR2 ON QueryR.Rs < QueryR2.Rs
                                                       GROUP BY QueryR.Batter,
                                                                QueryR.Rs
                                                       ORDER BY rRank ASC
                                                          LIMIT 5)
                                                    ORDER BY Rank ASC')
      @panel_top5_W = Pitching.find_by_sql('WITH Top5W(Pitcher,fName,lName,Ws,G) 
                                                      AS (SELECT PIT.player_id AS Pitcher,
                                                                 PLY.player_fname AS fName,
                                                                 PLY.player_lname AS lName, 
                                                                 SUM(PIT.W) AS Ws, 
                                                                 COUNT(*) AS G
                                                          FROM pitchings AS PIT, 
                                                               players AS PLY
                                                          WHERE PLY.player_id = PIT.player_id AND 
                                                                PLY.member = 1 ' +
                                                                @pitch_year +
                                                        ' GROUP BY PIT.player_id
                                                          HAVING SUM(PIT.W) > 0 
                                                          ORDER BY SUM(PIT.W) DESC, 
                                                                   SUM(PIT.W)/(SUM(PIT.W)+SUM(PIT.L)) DESC)
                                            SELECT QueryW.Pitcher AS ID,
                                                   QueryW.Ws AS Data,
                                                   QueryW.fName AS firstName,
                                                   QueryW.lName AS lastName,
                                                   COUNT(QueryW2.Ws)+1 AS Rank
                                                   FROM Top5W AS QueryW
                                                   LEFT JOIN Top5W AS QueryW2
                                                   ON QueryW.Ws < QueryW2.Ws
                                                   GROUP BY QueryW.Pitcher,
                                                            QueryW.Ws
                                                   HAVING Rank IN 
                                                       (SELECT COUNT(QueryW2.Ws)+1 AS wRank
                                                          FROM Top5W AS QueryW
                                                     LEFT JOIN Top5W AS QueryW2 ON QueryW.Ws < QueryW2.Ws
                                                      GROUP BY QueryW.Pitcher,
                                                               QueryW.Ws
                                                      ORDER BY wRank ASC
                                                         LIMIT 5)
                                                   ORDER BY Rank ASC')
      @panel_top5_SO = Pitching.find_by_sql('WITH Top5SO(Pitcher,fName,lName,SOs,IPs) 
                                                     AS (SELECT PIT.player_id AS Pitcher,
                                                                PLY.player_fname AS fName,
                                                                PLY.player_lname AS lName, 
                                                                SUM(PIT.SO) AS SOs, 
                                                                SUM(PIT.IPouts)/3 AS IPs
                                                          FROM pitchings AS PIT, 
                                                               players AS PLY
                                                          WHERE PLY.player_id = PIT.player_id AND 
                                                                PLY.member = 1 ' +
                                                                @pitch_year +
                                                        ' GROUP BY PIT.player_id
                                                          HAVING SUM(PIT.SO) > 0 
                                                          ORDER BY SUM(PIT.SO) DESC)
                                             SELECT QuerySO.Pitcher AS ID,
                                                    QuerySO.SOs AS Data,
                                                    QuerySO.fName AS firstName,
                                                    QuerySO.lName AS lastName,
                                                    COUNT(QuerySO2.SOs)+1 AS Rank
                                                    FROM Top5SO AS QuerySO
                                                    LEFT JOIN Top5SO AS QuerySO2
                                                    ON QuerySO.SOs < QuerySO2.SOs
                                                    GROUP BY QuerySO.Pitcher,
                                                             QuerySO.SOs
                                                    HAVING Rank IN 
                                                        (SELECT COUNT(QuerySO2.SOs)+1 AS soRank
                                                           FROM Top5SO AS QuerySO
                                                      LEFT JOIN Top5SO AS QuerySO2 ON QuerySO.SOs < QuerySO2.SOs
                                                      GROUP BY QuerySO.Pitcher,
                                                               QuerySO.SOs
                                                      ORDER BY soRank ASC
                                                         LIMIT 5)
                                                   ORDER BY Rank ASC')
      @panel_top5_ERA5 = Pitching.find_by_sql('WITH Top5ERA5(Pitcher,fName,lName,ERA5s,ERs,IPs) 
                                                         AS (SELECT PIT.player_id AS Pitcher,
                                                                    PLY.player_fname AS fName,
                                                                    PLY.player_lname AS lName,
                                                                    CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*15*100 AS INTEGER) AS REAL)/100.0 AS ERA5s,
                                                                    SUM(PIT.ER) AS ERs, 
                                                                    SUM(PIT.IPouts)/3 AS IPs
                                                               FROM pitchings AS PIT, 
                                                                    players AS PLY
                                                              WHERE PLY.player_id = PIT.player_id AND 
                                                                    PLY.member = 1 ' +
                                                                    @pitch_year +
                                                         ' GROUP BY PIT.player_id
                                                             HAVING (SUM(PIT.IPouts)/3 >= ' + @gameNumber.to_s + ' OR SUM(PIT.IPouts)/3 >= ' + @activePLAYER.to_s + ') 
                                                           ORDER BY SUM(PIT.ER)/SUM(PIT.IPouts+0.0000000000000000000000000000000000000001))
                                               SELECT QueryERA5.Pitcher AS ID,
                                                      QueryERA5.ERA5s AS Data,
                                                      QueryERA5.fName AS firstName,
                                                      QueryERA5.lName AS lastName,
                                                      COUNT(QueryERA52.ERA5s)+1 AS Rank
                                                      FROM Top5ERA5 AS QueryERA5
                                                      LEFT JOIN Top5ERA5 AS QueryERA52
                                                      ON QueryERA5.ERA5s > QueryERA52.ERA5s
                                                      GROUP BY QueryERA5.Pitcher,
                                                               QueryERA5.ERA5s
                                                      HAVING Rank IN 
                                                          (SELECT COUNT(QueryERA52.ERA5s)+1 AS era5Rank
                                                             FROM Top5ERA5 AS QueryERA5
                                                      LEFT JOIN Top5ERA5 AS QueryERA52 ON QueryERA5.ERA5s < QueryERA52.ERA5s
                                                      GROUP BY QueryERA5.Pitcher,
                                                               QueryERA5.ERA5s
                                                      ORDER BY era5Rank ASC
                                                         LIMIT 5)
                                                   ORDER BY Rank ASC')
      @panel_top5_ERA7 = Pitching.find_by_sql('WITH Top5ERA7(Pitcher,fName,lName,ERA7s,ERs,IPs) 
                                                         AS (SELECT PIT.player_id AS Pitcher,
                                                                    PLY.player_fname AS fName,
                                                                    PLY.player_lname AS lName,
                                                                    CAST(CAST(SUM(PIT.ER)/SUM(PIT.IPouts+0.00000000000000000000000000000000000000001)*21*100 AS INTEGER) AS REAL)/100.0 AS ERA7s,
                                                                    SUM(PIT.ER) AS ERs, 
                                                                    SUM(PIT.IPouts)/3 AS IPs
                                                               FROM pitchings AS PIT, 
                                                                    players AS PLY
                                                              WHERE PLY.player_id = PIT.player_id AND 
                                                                    PLY.member = 1 ' +
                                                                    @pitch_year +
                                                         ' GROUP BY PIT.player_id
                                                             HAVING (SUM(PIT.IPouts)/3 >= ' + @gameNumber.to_s + ' OR SUM(PIT.IPouts)/3 >= ' + @activePLAYER.to_s + ') 
                                                           ORDER BY SUM(PIT.ER)/SUM(PIT.IPouts+0.0000000000000000000000000000000000000001))
                                               SELECT QueryERA7.Pitcher AS ID,
                                                      QueryERA7.ERA7s AS Data,
                                                      QueryERA7.fName AS firstName,
                                                      QueryERA7.lName AS lastName,
                                                      COUNT(QueryERA72.ERA7s)+1 AS Rank
                                                      FROM Top5ERA7 AS QueryERA7
                                                      LEFT JOIN Top5ERA7 AS QueryERA72
                                                      ON QueryERA7.ERA7s > QueryERA72.ERA7s
                                                      GROUP BY QueryERA7.Pitcher,
                                                               QueryERA7.ERA7s
                                                      HAVING Rank IN 
                                                          (SELECT COUNT(QueryERA72.ERA7s)+1 AS era7Rank
                                                             FROM Top5ERA7 AS QueryERA7
                                                      LEFT JOIN Top5ERA7 AS QueryERA72 ON QueryERA7.ERA7s < QueryERA72.ERA7s
                                                      GROUP BY QueryERA7.Pitcher,
                                                               QueryERA7.ERA7s
                                                      ORDER BY era7Rank ASC
                                                         LIMIT 5)
                                                   ORDER BY Rank ASC')
      @panel_top5_WHIP = Pitching.find_by_sql('WITH Top5WHIP(Pitcher,fName,lName,WHIPs,IPs) 
                                                         AS (SELECT PIT.player_id AS Pitcher,
                                                                    PLY.player_fname AS fName,
                                                                    PLY.player_lname AS lName,
                                                                    (SUM(PIT.H)+SUM(PIT.BB)+0.0)/((SUM(PIT.IPouts)/3)+0.0) AS WHIPs, 
                                                                    SUM(PIT.IPouts)/3 AS IPs
                                                               FROM pitchings AS PIT, 
                                                                    players AS PLY
                                                              WHERE PLY.player_id = PIT.player_id AND 
                                                                    PLY.member = 1 ' +
                                                                    @pitch_year +
                                                         ' GROUP BY PIT.player_id
                                                             HAVING (SUM(PIT.IPouts)/3 >= ' + @gameNumber.to_s + ' OR SUM(PIT.IPouts)/3 >= ' + @activePLAYER.to_s + ')
                                                           ORDER BY (SUM(PIT.H)+SUM(PIT.BB)+0.0)/((SUM(PIT.IPouts)/3)+0.0))
                                               SELECT QueryWHIP.Pitcher AS ID,
                                                      QueryWHIP.WHIPs AS Data,
                                                      QueryWHIP.fName AS firstName,
                                                      QueryWHIP.lName AS lastName,
                                                      COUNT(QueryWHIP2.WHIPs)+1 AS Rank
                                                      FROM Top5WHIP AS QueryWHIP
                                                      LEFT JOIN Top5WHIP AS QueryWHIP2
                                                      ON QueryWHIP.WHIPs > QueryWHIP2.WHIPs
                                                      GROUP BY QueryWHIP.Pitcher,
                                                               QueryWHIP.WHIPs
                                                      HAVING Rank IN 
                                                          (SELECT COUNT(QueryWHIP2.WHIPs)+1 AS whipRank
                                                             FROM Top5WHIP AS QueryWHIP
                                                      LEFT JOIN Top5WHIP AS QueryWHIP2 ON QueryWHIP.WHIPs < QueryWHIP2.WHIPs
                                                      GROUP BY QueryWHIP.Pitcher,
                                                               QueryWHIP.WHIPs
                                                      ORDER BY whipRank ASC
                                                         LIMIT 5)
                                                   ORDER BY Rank ASC')
      @Max_age = Member.maximum("IM_age")
	  @memberQuery = Array.new(@Max_age)
	  @activelist = Array.new(@Max_age){0}
	  @captainlist = Array.new(@Max_age){0}
	  @deputylist = Array.new(@Max_age){0}
	  @GAlist = Array.new(@Max_age){0}
	  @counter_captain = 0
	  @counter_deputy = 0
	  @counter_GA = 0
	  for i in 0..(@Max_age-1) do
		@memberQuery[i] = memberQuery(i+1)
		@activelist[i] = memberQuery_active(i+1).length
		@captainlist[i] = memberQuery_leadership(i+1,1).length
		@counter_captain = @counter_captain + @captainlist[i]
		@deputylist[i] = memberQuery_leadership(i+1,2).length
		@counter_deputy = @counter_deputy + @deputylist[i]
		@GAlist[i] = memberQuery_leadership(i+1,3).length
		@counter_GA = @counter_GA + @GAlist[i]
	  end
	  
	  
	else
      #沒台大IP又沒登入
      redirect_to :action => 'new', :controller => 'sessions'
    end                                                     
	
  end

end
