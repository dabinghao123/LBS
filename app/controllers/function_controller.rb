class FunctionController < ApplicationController
	#encoding=UTF-8  
   require 'csv' 
   require 'json'
   require 'open-uri'
  def index
       @business=Business.all


        @customers=[]
        @buses=[]

        if request.post?

           if params[:num3]!=nil
              searchbus
              $business=@buses 
               $customer=nil 

            else

              serachcus
              
             $customer=@customers
              $business=nil
           end
          
      
      
        end

  end
#自动补全功能
     def autocomplete
         # business=Business.find_by_sql("select name from Businesses where name='%#{params[:name]}%'")
        business=Business.all
           #bs=Business.find_by_name(params[:haha])
        
          bs=[]
           business.each  do  |bus|
               bs<<bus.name
           end
            # bs=["java","ruby","python"]
                # bss=JSON.parse(bs)
                # ActiveSupport::JSON.decode("{1:2}") 

          render :json=>bs.to_json
    end
#上传顾客信息
    def  customer
     @provinces=Province.all
      if request.post?
         
      uploaded_io = params[:file]
       if uploaded_io==nil
           flash.now[:notice]="请选择文件"
        return
         
       end
      cid=params[:city].to_i

      if cid==0
        flash.now[:notice]="请选择城市"
        return
      end

      @citys=Province.find(cid)

       File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
       file.write(uploaded_io.read)
       end 
      
      Thread.new do
       begin
           @c=CSV.read("public/uploads/#{uploaded_io.original_filename}")
       rescue Exception =>e
    
          msg=e.message.match(/\d+/)[0]

         flash.now[:notice]="文档中第#{msg}行有错误请核实后再上传"
         return
       end    
       i=0

       while @c[i]!=nil
          t=Customer.new
          t.nickname=@c[i][0]
          t.name=@c[i][1]
          t.address=@c[i][2]
          t.tel=@c[i][3]
          t.province_id=cid
          loaddata(t.address,@citys.city)
          t.lat=@lats
          t.lng=@lngs
      
          i=i+1
          if @lats<=10||@lngs<=10
            
            next

         else
             t.save
            
          end

         end 
     end
    # thread ending
   flash.now[:notice]="csv文件上传成功！!如果数据有上万条请30分钟后进行其他操作"

    end
   
   end
#上传商家信息
     def business
    @provinces=Province.all
   if request.post?


      cid=params[:city].to_i
       if cid==0
        flash.now[:error]="请选择城市"
        return
      end
    uploaded_io = params[:file]
       if uploaded_io==nil
           flash.now[:error]="请选择文件"
        return
      end

      @citys=Province.find(cid)
      
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    file.write(uploaded_io.read)
    end
   
     # thread start
       Thread.new do 
        begin
           @c=CSV.read("public/uploads/#{uploaded_io.original_filename}")
        rescue Exception => e
             msg=e.message.match(/\d+/)[0]

             flash.now[:notice]="文档中第#{msg}行有错误请核实后再上传"
         return
        end
     
      i=0;
       
      while @c[i]!=nil
          t=Business.new
          t.typename=@c[i][0]
          t.name=@c[i][1]
          t.address=@c[i][2]
          # t.tel=@c[i][2]
          t.province_id=cid
          loaddata(t.address,@citys.city)
          t.lat=@lats
          t.lng=@lngs
          i=i+1
         if @lats<=10||@lngs<=10
            
         next

         else
             t.save
            
          end
         
          
      end 

    #thread ending
     end
        flash.now[:notice]="csv文件上传成功！!如果数据有上万条请30分钟后进行其他操作"
        #render :text=>@citys[city]
 end
end

#根据地址和城市查询经纬度
   def  loaddata(address,city)
     
         url="http://api.map.baidu.com/geocoder/v2/?ak=9fa042b62dac3a4716a35b5faa552a8c&output=json&address=#{address}
&city=#{city}"
         urls=URI.encode(url)
         jsonstext=open(urls).read
         jsons=JSON.parse(jsonstext)
              
         if jsons["result"]==nil || jsons["result"].length==0
             @lngs=10
             @lats=10
           else
             @lngs=jsons['result']['location']['lng']
             @lats=jsons['result']['location']['lat']
           
         end
         
    end
     
#下载查询周边的顾客信息和商家信息
def download


  if $customer!=nil

      cus=[]
     File.new("public/uploads/new.csv","w")

     CSV.open("public/uploads/new.csv","wb") do |csv|
         $customer.each do |cuss|
              cus<<cuss.name
              cus<<cuss.address
              cus<<cuss.tel
              csv<<cus
              cus=[]
             end
          end
          
       
   else

     bus=[]
     File.new("public/uploads/new.csv","w")

     CSV.open("public/uploads/new.csv","wb") do |csv|
         $business.each do |buss|
              bus<<buss.typename
              bus<<buss.name
              bus<<buss.address
              #bus<<cuss.tel
              csv<<bus
              bus=[]
             end
          end
      end

        send_file "public/uploads/new.csv"
        # render(:file=>"public/uploads/new.csv") 

end

# 商家搜索商家


    def searchbus

          bus=Business.find(params[:sid])
          @business=Business.where("province_id=#{bus.province_id}")

            if params[:num3].to_i==1
                 
                     @business.each do  |buss|
                      # delete bus.id
                         if bus.id !=buss.id
                              if (buss.lng*100000-bus.lng*100000)**2+(buss.lat*100000-bus.lat*100000)**2<1000**2
                                   @buses<<buss
                        
                              else
                                  next
                              end
                        
                              end
                         end      
              
         
          elsif params[:num3].to_i==2
                  
                   @business.each do  |buss|
                      if bus.id!=buss.id
                        if (buss.lng*100000-bus.lng*100000)**2+(buss.lat*100000-bus.lat*100000)**2<2000**2
                          @buses<<buss
                        
                     else
                          next
                     end

                   end    
                    

                    end  

             else

              @business.each do  |buss|
                        if bus.id !=buss.id
                             if (buss.lng*100000-bus.lng*100000)**2+(buss.lat*100000-bus.lat*100000)**2<3000**2
                                  @buses<<buss
                        
                              else
                                  next
                             end
                           
                        end 
                    
             end  
                
             end
      
    end

#商家搜索顾客

    def serachcus
               
         
# 
          if  params[:name]!=nil
                  bus=Business.find_by_name(params[:name])
                  # 根据商家所在的城市查出查询出顾客信息所有信息
                  cuss=Customer.where("province_id=#{bus.province_id}")
                
          if bus!=nil
                 
            if params[:num].to_i==1
                 
                      cuss.each do  |cus|
                          if (bus.lng*100000-cus.lng*100000)**2+(bus.lat*100000-cus.lat*100000)**2<1000**2&&cus.lat!=nil
                                @customers<<cus
                        
                           else
                                next
                          end

                      end      
              
         
          elsif params[:num].to_i==2
                  
                  cuss.each do  |cus|
                         
                     if (bus.lng*100000-cus.lng*100000)**2+(bus.lat*100000-cus.lat*100000)**2<2000**2
                      @customers<<cus
                        
                     else
                          next
                     end

                    end  

             else

              cuss.each do  |cus|
                         
                     if (bus.lng*100000-cus.lng*100000)**2+(bus.lat*100000-cus.lat*100000)**2<3000**2
                      @customers<<cus
                        
                     else
                          next
                     end

              end  
                
             end

             # end  1 2 3

                    else


                    
                  end


                 
           else
            
            #查询出商家的信息
             bus=Business.find(params[:sid])
             # 根据商家所在的城市查出查询出顾客信息所有信息
          cuss=Customer.where("province_id=#{bus.province_id}")
  #  first  
            if params[:num2].to_i==1
                 
                 cuss.each do  |cus|
                         
                if (bus.lng*100000-cus.lng*100000)**2+(bus.lat*100000-cus.lat*100000)**2<1000*1000&&cus.lat!=nil
                   @customers<<cus
                        
                     else
                          next
                     end
                   
                 end      
                flash.now[:notice]="查询成功！1公里的范围!"     
         
          elsif params[:num2].to_i==2
                  
                  cuss.each do  |cus|
                         
                     if (bus.lng*100000-cus.lng*100000)**2+(bus.lat*100000-cus.lat*100000)**2<(2000**2)
                      @customers<<cus
                        
                     else
                          next
                     end

                 end  
             flash.now[:notice]="查询成功！2公里的范围!"
             else
              cuss.each do  |cus|
                         
                     if (bus.lng*100000-cus.lng*100000)**2+(bus.lat*100000-cus.lat*100000)**2<3000**2
                      @customers<<cus
                        
                     else
                          next
                     end

                 end  
                flash.now[:notice]="查询成功！3公里的范围!"
             end
# end ----if  1 2  3

            
           end
      
    end
#群发发送短信
    def  sendfrom
         if $customer
             @cust=$customer
            else

              @cust=[]
         end
      if @jsonstext==0 
       flash.now[:notice]="短信发送成功!"
      elsif @jsonstext==nil
             flash.now[:notice]="使用httpget发送短信!"
      else
         flash.now[:error]="短信发送失败!"
      end
    end

#群发发送短信
    def sendmsg
      content=params[:content]
      send=params[:mobile]
      sends=send.strip
      mobile=sends.gsub("\r\n",";")
      url="http://116.213.72.20/SMSHttpService/send.aspx?username=cdxx&password=cdxx&mobile=#{mobile}&content=#{content}&Extcode=&senddate=&batchID"
     # url="http://211.154.157.160:7777/send.asp?userid=40818&userpass=123456&urllongsms=0&content=#{content}&mobile=#{mobile}"
      urls=URI.encode(url)
      @jsonstext=open(urls).read
     
      redirect_to  action: "sendfrom"
      #render:text=>jsonstext
    end
    
    

end
