# coding: utf-8

class AnalyseData

  BASE_INDEX = {
    "帐户信息" => %w(预存款结余 结余项 溢收款结余 宽带直降赠款抵扣 营销首月赠款抵扣 本期结转 本期结转零头费 分月返还预存款抵扣 上期结转零头费 上期违约金 下期结转零头费 溢收款抵扣 预存款抵扣 赠款抵扣 赠送话费抵扣),
    "月基本费" => %w(可选包 移动语音包 广告铃音尊享包信息费 号码百事通功能费 集团彩铃功能费 商企通功能费 副卡套餐费 天翼乐享套餐费 停机保号费 总机分机功能费 VPN可选包 *挂机短信功能费 *来电名片功能费 e家套餐费 IPTV可选包 本地语音包 短信包 固话月租费 固网同振包 加装包 宽带年付费 宽带月租费 来电显示功能费 漫游包 七彩铃音功能费 企业总机包 企业总机功能费 商务领航套餐 商务领航套餐费 商务领航通信版套餐费 商务领航旺铺通套餐 商务领航旺铺通套餐费 套餐费 同振顺呼功能费 旺铺通套餐费 无线宽带套餐费 移动来电显示功能费 移动七彩铃音功能费 移动上网包 移动月租费 长途包 长途套餐费 长途语音包 直线电话年付费),
    "代收费" => ['*代收信元wap费', '*代收空中信使UTK1短信费', '*代收信元短信费', '*代收爱音乐铃音费', '*代收全网掌上通短信费', '*代收中国电信爱音乐短信费', '*代收小额支付', '*代收95000声讯费', '*代收翼周边wap费', '*代收号百信息短信费', '*代收天行汇通短信费', '*代收青牛短信费', '*代收北京搜狐UTK2短信费', '*代收950509通话费', '*代收极品无限BREW信息费', '*代收天翼空间brew信息费', '*代收缤纷时空BREW信息费', '*代收长城软件BREW信息费', '*代收网易达BREW信息费', '*代收星信BREW信息费', '*代收美宁BREW信息费', '*代收魔百创娱BREW信息费', '*代收众赞科技brew信息费', '*代收天行汇通BREW信息费', '*代收全点BREW信息费', '*代收陕西天盟brew信息费', '*代收幸福无线BREW信息费', '*代收捷通华声BREW信息费', '*代收广茂思路BREW信息费', '*代收中天和信BREW信息费', '*代收号百BREW信息费', '*代收铃音信息费', '*代收全网乐视移动短信费', '*代收全网新浪短信费', '*代收新闻早晚报', '*代收95001声讯费', '*代收爱动漫信息费', '*代收费新闻早晚报', '*代收号百451wap费', '*代收铃声信息费', '*代收全网互通无限WAP费', '*代收全网空中信使短信费', '*代收全网雷霆万钧WAP费', '*代收全网联通华建短信费'],
    "短信彩信费"       => %w(*挂机短信短信费 彩信费 移动短信费 优惠招财宝短信费 招财宝短信费 招财宝功能费 *来电名片短信费),
    "其他费"          => %w(调整通信费 话费补差 流量补差),
    "上网及数据通信费"  => %w(上网通信费 无线宽带漫游上网费 无线宽带上网费),
    "一次性费用"       => %w(移动手续费 移动停机费 工料费 来电显示功能费 来电显示开户费 手续费 移机保号服务费 安装调测费),
    "优惠费用"         => %w(e家优惠费),
    "语音通信费"       => %w(台港澳通话费 国际通话费 国内呼转通话费 港澳台通话费 固话本地通话费 固话本地通话费抵扣 固话本地通信费 固话本点通话费 固话群内通话费 国内通话费 移动IP国内通话费 移动本地通话费 移动国内漫游费 移动国内通话费 移动国内通信费 优惠港澳台通话费 优惠固话本地通话费 优惠固话群内通话费 优惠国内通话费 优惠移动本地通话费 优惠移动国内漫游费 优惠移动国内通话费 分时计费国内通话费 IP国内通话费),
    "综合信息服务费"    => ['*代收音乐下载信息费', '118166多方通话', '*爱动漫信息费', '*商家名片功能费', '*代收中国电信股份有限公司wap费', '*代收爱游戏信息费', '商务彩铃服务费', '*代收96860声讯费', '*音证宝功能费', '*爱游戏信息费', '*代收119818费', '*代收118918费', '*代收160声讯费', '*代收168声讯费', '*天翼空间信息费', '*天翼视讯信息费', '*天翼阅读信息费', '代收118918费', '代收168声讯费', '音乐下载信息费'],
  }

  def self.analyse file_name
    file_path = "#{file_name}.txt"

    call_number = nil
    datas = {}
    billing_message = {}
    billing_no = {}
    phone_content = {}
    single_phone = {}

    n = 0
    File.open(file_path, "r") do |file|
      while line = file.gets
        n += 1

        line_ary = line.split(" ")
        next if line_ary[0] == "主叫号码" # 去掉首行

        if line_ary[0] == "小计:"
          single_phone.merge!({"小计" => line_ary[1]})
          phone_content[call_number] = single_phone
          billing_no.merge! phone_content

          phone_content = {}
          single_phone = {}
          call_number = nil
          next
        end

        # 账户信息二级项目
        if key = get_parent_key(line_ary[0])
          billing_message[key][line_ary[0]] = line_ary[1]
          next
        end

        if line_ary[0] == "帐户信息"
          billing_message[line_ary[0]] = {line_ary[0] => line_ary[1]}
          next
        end

        if line_ary[0] =~ /总计/
          index = line_ary[0][3..-1]
          datas[index] = {"总计" => line_ary[1]}
          datas[index].merge! billing_message # 帐户信息
          datas[index].merge! billing_no
          billing_message = {}
          billing_no = {}
          next
        end

        # 号码
        call_number ||= line_ary[0]

        # 判断一级项目
        if BASE_INDEX.has_key? line_ary[1]
          single_phone[line_ary[1]] = {line_ary[1] => line_ary[2]}
          next
        end

        # 判断二级项目
        if key = get_parent_key(line_ary[1])
          if single_phone[key][line_ary[1]].nil?
            single_phone[key][line_ary[1]] = {line_ary[1] => line_ary[2], times: line_ary[3]}
          else
            for i in 1..3
              break single_phone[key]["#{line_ary[1]}-#{i}"] = {"#{line_ary[1]}-#{i}" => line_ary[2], times: line_ary[3]} if single_phone[key]["#{line_ary[1]}-#{i}"].nil?
            end
          end
          next
        else
          raise "第#{n}行， #{line_ary[1]} Not Found！"
        end
      end

      datas
    end
  end

  def self.export file_name
    records = analyse file_name
    is_first = true

    f = File.new "#{file_name}.csv", 'w'


    records.each do |key, value|
      bill_header = ['分账序号']
      bill_data = [key]

      value.each do |k, v|
        if k == "总计"
          bill_header << k
          bill_data << v

          # 部分分账序号没有帐户信息
          unless value["帐户信息"]
            bill_header << "帐户信息"
            bill_data << nil

            BASE_INDEX["帐户信息"].each do |c|
              bill_header << c
              bill_data << nil
            end
          end

          next
        end

        if k == "帐户信息"
          bill_header << k
          bill_data << v[k]

          BASE_INDEX["帐户信息"].each do |c|
            bill_header << c
            bill_data << v[c]
          end

          next
        end

        call_no_header = ['号码']
        call_no_data = [k]

        BASE_INDEX.each do |index, children|
          # next if index == "帐户信息"

          if index == "语音通信费" || index == "短信彩信费"
            call_no_header << index
            call_no_data << (v[index] ? v[index][index] : nil)

            children.each do |i|
              for n in 0..3
                if n == 0
                  children_index = i
                else
                  children_index = "#{i}-#{n}"
                end

                call_no_header << children_index
                call_no_header << "#{children_index}_times" if index == "语音通信费"

                if v[index]
                  call_no_data << (v[index][children_index] ? v[index][children_index][children_index] : nil)
                  call_no_data << (v[index][children_index] ? v[index][children_index][:times] : nil) if index == "语音通信费"
                else
                  call_no_data << nil
                  call_no_data << nil if index == "语音通信费"
                end
              end
            end
          elsif index == "帐户信息"
            call_no_header << "#{index}_c"
            call_no_data << (v[index] ? v[index][index] : nil)

            children.each do |i|
              call_no_header << "#{i}_c"
              if v[index]
                call_no_data << (v[index][i] ? v[index][i][i] : nil)
              else
                call_no_data << nil
              end
            end
          else
            call_no_header << index
            call_no_data << (v[index] ? v[index][index] : nil)

            children.each do |i|
              call_no_header << i
              if v[index]
                call_no_data << (v[index][i] ? v[index][i][i] : nil)
              else
                call_no_data << nil
              end
            end
          end
        end

        call_no_header << "小计"
        call_no_data << v["小计"]

        # 表头只写入一次
        if is_first
          f.puts (bill_header + call_no_header).join(",").encode(Encoding.find('GBK'), {invalid: :replace, undef: :replace, replace: ''})
          is_first = false
        end

        f.puts (bill_data + call_no_data).join(",").encode(Encoding.find('GBK'), {invalid: :replace, undef: :replace, replace: ''})

      end

      bill_header = [] # 清空bill表头
      bill_data = [] # 清空bill数据
    end

    f.close
  end

  private
  def self.get_parent_key(value)
    BASE_INDEX.each do |key, val|
      return key if val.include? value
    end

    return nil
  end
end

AnalyseData.export ARGV[0]

