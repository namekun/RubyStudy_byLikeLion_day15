class KakaoController < ApplicationController
  def keyboard #사용자가 처음에 채팅방에 들어왔을때.
    @keyboard = {
    :type => "buttons",
    :buttons => ["로또","날씨","댕댕이"]
    }
    render json: @keyboard # json으로 value값은 keyboard를 렌더링
  end
  
  def message
    @user_msg = params[:content]
    @text = "기본 텍스트"
    
    if @user_msg == "로또"
      number = *(1..45)
      lotto = number.sample(6).sort
      @text = "이번주 추천 로또 번호는" + lotto.to_s + "입니다."
    elsif @user_msg == "날씨"
      responseNaverMo =HTTParty.get("https://weather.naver.com/rgn/cityWetrCity.nhn?cityRgnCd=CT001013")
      responseNaverAf =HTTParty.get("https://weather.naver.com/rgn/cityWetrCity.nhn?cityRgnCd=CT001013")
      responseNaverWthinfo  =HTTParty.get("https://weather.naver.com/rgn/cityWetrCity.nhn?cityRgnCd=CT001013")

      moweatherNV = Nokogiri::HTML(responseNaverMo)
      afweatherNV = Nokogiri::HTML(responseNaverAf)
      weatherinfo = Nokogiri::HTML(responseNaverWthinfo)

      resultwthmo = moweatherNV.css("#content > table.tbl_weather.tbl_today3 > tbody > tr > td:nth-child(1) > div:nth-child(1) > ul > li.nm > span")
      resultwthaf = afweatherNV.css("#content > table.tbl_weather.tbl_today3 > tbody > tr > td:nth-child(1) > div:nth-child(3) > ul > li.nm > span")
      resultfeel = weatherinfo.css("#content > div.w_now2 > ul > li:nth-child(1) > div > em > strong")

      @text = "금일 강남구 역삼동의 오전은 #{resultwthmo.text}℃이고, 오후는 #{resultwthaf.text}℃ 이며, 오늘은 #{resultfeel.text}입니다."
    # elsif @user_msg == "고양이"
    #   @url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
    #   @cat_xml = RestClient.get(@url) # url에 대한 응답을 저장
    #   @cat_doc = Nokogiri::XML(@cat_xml) # 노코기리를 통해서 데이터를 정제
    #   @cat_url = @cat_doc.xpath("//url").text
    #   @text = @cat_url
    # end
    elsif @user_msg == "댕댕이"
        @dog = "https://api.thedogapi.com/v1/images/search?format=src&mime_types=image/jpg"
        @text = @dog
    end  
        
    
    @return_msg = { # 메세지 필드에 대한 값으로 들어갈 것
      :text => @text # 사용자가 어떤 버튼을 눌렀는지를 보여준다.
      
    }
    @return_msg_photo = { # 사진까지 같이 보내야할때에는 임마를 사용
      text: "이것은 귀여운 댕댕이다.",
      photo: { 
        "url": @dog,
        "width": 640,
        "height": 480
        
      }
    }
    
    @return_keyboard = { # 키보드에 대한 value값으로 들어간다.
      :type => "buttons",
      :buttons => ["로또","날씨","댕댕이"]
    }
    
    if @user_msg == "댕댕이"
      @result = { #result에 값을 준다
        :message => @return_msg_photo, 
        :keyboard => @return_keyboard
      }
    else
       @result = { #result에 값을 준다
        :message => @return_msg, 
        :keyboard => @return_keyboard
      }
    end

    
    render json: @result # @result를 json형태로 렌더링
  
  
  end  
end
