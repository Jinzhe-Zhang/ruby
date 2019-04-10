begin
class Node
    attr_accessor :left,:right,:value,:black,:name
    def initialize(e,n="")
        @left,@right,@value,@black,@name=nil,nil,e,false,n
    end
    def print
        return (@name+(@black ? "◆" : "◇")+@value.to_s)
    end
end
class RBT
    @@root=nil
    def initialize(*op)
        @jl=[]
        op.each { |e|
            add(e)
        }
    end
    def brother(n)
        if @jl[n-1]
            return @jl[n-2].left
        else
            return @jl[n-2].right
        end
    end
    def update_fathernode(pos,n)
        if pos==0
            @@root=n
            $ope+="将根设置成#{n ? n.print : "nil"}\n"
        elsif @jl[pos-1]
            @jl[pos-2].right=n
            $ope+="将#{@jl[pos-2].print}的右枝设置成#{n ? n.print : "nil"}\n"
        else
            @jl[pos-2].left=n
            $ope+="将#{@jl[pos-2].print}的左枝设置成#{n ? n.print : "nil"}\n"
        end
    end
    def rotate
        $ope+="取局部的树\n#{draw(@jl[-5])}"
        newfamily=[]
        $ope+="根据三个结点#{@jl[-5].print},#{@jl[-3].print},#{@jl[-1].print}以及其左，右枝将此局部树从左到右分成7个部分：\n"
        if @jl[-2] and @jl[-4]
            newfamily=[@jl[-5].left,@jl[-5],@jl[-3].left,@jl[-3],@jl[-1].left,@jl[-1],@jl[-1].right]
        elsif @jl[-2]
            newfamily=[@jl[-3].left,@jl[-3],@jl[-1].left,@jl[-1],@jl[-1].right,@jl[-5],@jl[-5].right]
        elsif @jl[-4]
            newfamily=[@jl[-5].left,@jl[-5],@jl[-1].left,@jl[-1],@jl[-1].right,@jl[-3],@jl[-3].right]
        else
            newfamily=[@jl[-1].left,@jl[-1],@jl[-1].right,@jl[-3],@jl[-3].right,@jl[-5],@jl[-5].right]
        end
        $ope+="#{draw(newfamily[0])}#{newfamily[1].print}\n#{draw(newfamily[2])}#{newfamily[3].print}\n#{draw(newfamily[4])}#{newfamily[5].print}\n#{draw(newfamily[6])}"
        newfamily[3].left,newfamily[3].right,newfamily[1].left,newfamily[1].right,newfamily[5].left,newfamily[5].right=newfamily[1],newfamily[5],newfamily[0],newfamily[2],newfamily[4],newfamily[6]
        $ope+="将中间结点#{newfamily[3].print}作为父亲，结点#{newfamily[1].print}，#{newfamily[5].print}作为左右子\n剩下四个枝从左到右依次接到两个子的左右枝,形成新的局部树:\n#{draw(newfamily[3])}"
        newfamily[3].black,@jl[-5].black=@jl[-5].black,newfamily[3].black
        $ope+="新父，旧祖父红黑互换\n#{draw(newfamily[3])}将局部树嫁接到原树上：\n"
        update_fathernode(@jl.length-5,newfamily[3])
        $ope+=draw
    end
    def fitadd
        $ope+="进行插入节点的调整操作\n"
        loop {$ope+="考虑结点:#{@jl[-1].print}及其父#{@jl[-3].print}\n"
            if @jl[-3].black
                $ope+="父结点为黑色，结束调整"
                return
            elsif brother(-3) and !brother(-3).black
                $ope+="父结点为红色，则看他的伯伯#{brother(-3).print}\n"
                brother(-3).black,@jl[-3].black,@jl[-5].black= true,true,false
                $ope+="伯伯为红色，黑爸黑伯红祖父\n#{draw}"
                if @jl.length<=5
                    $ope+="祖父为根，结束调整\n"
                    break
                end
                $ope+="祖父不为根，继续对祖父进行调整\n"
                @jl.pop(4)
            else
                $ope+="父结点为红色，则看他的叔叔#{brother(-3) ? brother(-3).print : "nil"}\n"
                $ope+="伯伯为黑色（nil默认为黑色），则进行旋转操作\n"
                rotate
                break
            end
        }
    end
    def add(e,n="")
        $ope="操作:增添结点#{n}:#{e}    原红黑树:\n#{draw}"
        $ope+="我们寻找一下#{n}:#{e}的插入位置:\n"
        if @@root
            @jl=[@@root]
            $ope+="以根#{@@root.print}作为初始寻找结点:\n"
            while @jl[-1]
                if @jl[-1].value>e
                    $ope+="#{e}比#{@jl[-1].value}小，转到左结点#{@jl[-1].left ? @jl[-1].left.print : "nil"}再进行比较\n"
                    @jl<<false<<@jl[-2].left
                else
                    $ope+="#{e}比#{@jl[-1].value}大，转到右结点#{@jl[-1].right ? @jl[-1].right.print : "nil"}再进行比较\n"
                    @jl<<true<<@jl[-2].right
                end
            end
            if @jl[-2]
                @jl[-1]=@jl[-3].right=Node.new(e,n)
            else
                @jl[-1]=@jl[-3].left=Node.new(e,n)
            end
            $ope+="遇空结点，跳出循环，将新结点#{@jl[-1].print}插入这个位置（初始红色）\n#{draw}然后\n"
            fitadd
        else
            @@root=Node.new(e,n)
            $ope+="现在树没有根，直接在根结点插入#{e}:\n#{draw}不用调整\n"
        end
        @@root.black = true
        $ope+="最后把根结点染成黑的，完成！\n#{draw}"
        $operation<<$ope
    end
    def reverse(m,n)
        $ope+="互换两结点#{@jl[m].print}和#{@jl[n].print}的左右枝\n这里应该注意的是若两结点有父子关系，方向（左枝或右枝）设为A\n则原儿子的A枝应被替换为原父亲而不再是原父亲的A枝了"
        if n-m ==2
            $ope+="这里#{@jl[m].print}是#{@jl[n].print}的父亲，#{@jl[n].print}的#{@jl[m+1] ? "右" : "左"}枝应设为#{@jl[m].print}"
        elsif m-n == 2
            $ope+="这里#{@jl[n].print}是#{@jl[m].print}的父亲，#{@jl[m].print}的#{@jl[n+1] ? "右" : "左"}枝应设为#{@jl[n].print}"
        else
            $ope+="不过这次两结点不是父子关系，就不用管了"
        end
        i,j,k,l=@jl[m].left,@jl[m].right,@jl[n].left,@jl[n].right
        @jl[m].left,@jl[m].right,@jl[n].left,@jl[n].right = k==@jl[m] ? @jl[n] : k,l==@jl[m] ? @jl[n] : l,i==@jl[n] ? @jl[m] : i,j==@jl[n] ? @jl[m] : j
        if m-n !=2
            $ope+="#{@jl[n].print}不是#{@jl[m].print}的父亲，互换后也不会是它的儿子，说明互换后#{@jl[m].print}的父亲在原树上，需要嫁接。"
            update_fathernode(m,@jl[n])
        end
        if n-m !=2
            $ope+="#{@jl[m].print}不是#{@jl[n].print}的父亲，互换后也不会是它的儿子，说明互换后#{@jl[n].print}的父亲在原树上，需要嫁接。"
            update_fathernode(n,@jl[m])
        end
        $ope+="最后交换颜色\n"
        @jl[m].black,@jl[n].black=@jl[n].black,@jl[m].black
        @jl[m],@jl[n]=@jl[n],@jl[m]
    end
    def smallrotate
        if @jl[-2]
            $ope+="左旋结点#{@jl[-1].print}，#{@jl[-3].print}\n"
            @jl[-1].left,@jl[-3].right=@jl[-3],@jl[-1].left
        else
            $ope+="右旋结点#{@jl[-1].print}，#{@jl[-3].print}\n"
            @jl[-1].right,@jl[-3].left=@jl[-3],@jl[-1].right
        end
        update_fathernode(@jl.length-3,@jl[-1])
        @jl[-1],@jl[-3],@jl[-2]=@jl[-3],@jl[-1],!@jl[-2]
        $ope+="交换旋转结点#{@jl[-1].print}，#{@jl[-3].print}的颜色\n"
        @jl[-1].black,@jl[-3].black=@jl[-3].black,@jl[-1].black
        $ope+="完成旋转#{draw}\n"
    end
    def find(e)
        $ope+="我们寻找一下值为#{e}的结点:\n"
        if @@root
            $ope+="以根#{@@root.print}作为初始寻找结点:\n"
            @jl=[@@root]
            while @jl[-1]
                if @jl[-1].value>e
                    $ope+="#{e}比#{@jl[-1].value}小，转到左结点#{@jl[-1].left ? @jl[-1].left.print : "nil"}再进行比较\n"
                    @jl<<false<<@jl[-2].left
                elsif @jl[-1].value<e
                    $ope+="#{e}不大于#{@jl[-1].value}，转到右结点#{@jl[-1].right ? @jl[-1].right.print : "nil"}再进行比较\n"
                    @jl<<true<<@jl[-2].right
                else
                    $ope+="#{e}与#{@jl[-1].value}相等，结束寻找，结点为#{@jl[-1].print}\n"
                    return true
                end
            end
            $ope+="然而并没有找到想要的结点"
        end
        return false
    end
    def del(e)
        $ope="操作:删除值为#{e}的元素    原红黑树:\n#{draw}"
        if find(e)
            while @jl[-1].left && @jl[-1].right
                pp=@jl.length-1
                @jl<<false<<@jl[-2].left
                while @jl[-1].right
                    @jl<<true<<@jl[-2].right
                end
                $ope+="#{@jl[-1].print}有左右枝，找左枝的最右结点#{@jl[-1].print}与它交换\n以下是交换操作:\n"
                reverse(pp,@jl.length-1)
                $ope+="交换结束\n#{draw}对#{@jl[-1].print}进行进一步的操作\n"
            end
            if @jl[-1].left
                $ope+="#{@jl[-1].print}只有左枝\n将左结点#{@jl[-1].left.print}涂黑接到#{@jl[-1].print}位置\n"
                @jl[-1].left.black= true
                update_fathernode(@jl.length-1,@jl[-1].left)
            elsif @jl[-1].right
                $ope+="#{@jl[-1].print}只有右枝\n将右结点#{@jl[-1].right.print}涂黑接到#{@jl[-1].print}位置\n"
                @jl[-1].right.black= true
                update_fathernode(@jl.length-1,@jl[-1].right)
            else
                $ope+="#{@jl[-1].print}为叶子结点，将其删除\n"
                update_fathernode(@jl.length-1,nil)
                if @jl[-1].black
                    $ope+="#{@jl[-1].print}是黑色，进行修复双黑操作\n"
                    fitdel
                else
                    $ope+="#{@jl[-1].print}是红色，不用修复双黑，直接完成\n"
                end
            end
            $ope+="完成del操作\n#{draw}"
            $operation<<$ope
        end
    end
    def redson(n)
        return ((n.left and not n.left.black) or (n.right and not n.right.black))
    end
    def fitdel
        loop {
            $ope+="对#{@jl[-1].print}修复双黑\n"
            if @jl.length==1
                $ope+="然而#{@jl[-1].print}是根，停止修复\n"
                break
            elsif !brother(-1)
                $ope+="#{@jl[-1].print}无兄弟结点，故转到其父进行修复\n"
                @jl.pop(2)
            else
                if !brother(-1).black
                    $ope+="#{@jl[-1].print}兄弟结点#{brother(-1).print}为红，染红父亲，染黑兄弟\n#{draw}"
                    die,@jl[-1],@jl[-2]=@jl[-1],brother(-1),!@jl[-2]
                    smallrotate
                    @jl<<@jl[-2]<<die
                    $ope+="之后重新对#{die.print}进行操作\n"
                end
                if redson(brother(-1))
                    $ope+="#{@jl[-1].print}兄弟结点#{brother(-1).print}为黑且有红子\n"
                    @jl[-1]=brother(-1)
                    @jl[-2]=!@jl[-2]
                    if @jl[-1].left and !@jl[-1].left.black
                        @jl<<false<<@jl[-2].left
                    else
                        @jl<<true<<@jl[-2].right
                    end
                    $ope+="将红子#{@jl[-1].print}染黑\n"
                    @jl[-1].black = true
                    $ope+="对#{@jl[-1].print}，#{@jl[-3].print}，#{@jl[-5].print}进行旋转操作\n"
                    rotate
                    break
                else
                    $ope+="兄弟黑色无红子，染红兄弟#{brother(-1).print}看父亲\n"
                    brother(-1).black= false
                    if @jl[-3].black
                        $ope+="父亲也是黑色，需要把双黑传递给父亲，对父亲的兄弟进行操作\n#{draw}"
                        @jl.pop(2)
                    else
                        $ope+="父亲是红色，染黑就合法了\n"
                        @jl[-3].black = true
                        $ope+="#{draw}"
                        break
                    end
                end
            end
        }
    end
    def drawnode(x,n)
        if n
            s=drawnode(x+10,n.left)+[" "*x+"#{n.print}          "]+drawnode(x+10,n.right)
            t=!n.left && n.right
            s.map! { |e| 
                if e[x+10]!=" "
                    t=!t
                    if e[x]==" "
                        e[x+9]="|"
                    else
                        e[x+8]="|"
                    end
                end
                if t
                    if e[x]==" "
                        e[x+9]="|"
                    else
                        e[x+8]="|"
                    end
                end
                e
            }
            return s
        else
            return []
        end
    end
    def draw(n=@@root)
        if n
            d=drawnode(0,n).map { |e|e.chomp  }
            indent=60-d.map { |e| e.length }.max/2
            d.map! { |e| " "*indent+e }
            return d.join("\n")+"\n"
        end
        return "                                                  连根儿都木有的空树\n"
    end
end
$operation=[]
$rbt=RBT.new()
$state=0
$input=[]
$info="等待输入"
$infol=8
$viewinput=false
Show={"welcome1" => "◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆   ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇
◆◆◆◆◆◆◇◇◇◇◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆   ◇◇◇◇◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◇◇◇
◆◆◆◆◆◆◇◇◇◇◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆   ◇◇◇◇◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◇◇◇
◆◆◆◆◆◆◇◇◇◆◆◆◆◇◇◇◆◆◆◆◆◆◇◇◇◇◆◆◆   ◇◇◇◇◆◆◆◇◇◇◆◇◇◇◆◆◇◇◇◆◇◇◇◆◆◇◇◇◇
◆◆◆◆◆◇◇◇◆◆◆◆◆◇◇◇◇◇◇◇◇◇◇◇◇◇◆◆◆   ◇◇◇◇◆◆◆◇◆◆◆◆◇◇◆◆◇◇◆◆◆◆◇◆◆◇◇◇◇
◆◆◆◆◆◇◇◇◆◆◇◆◆◇◇◇◇◇◇◇◇◇◇◇◇◇◆◆◆   ◇◇◇◇◇◆◆◇◆◆◆◆◇◇◆◆◇◇◆◆◆◇◇◆◆◇◇◇◇
◆◆◆◆◇◇◇◆◆◆◇◇◇◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◇◇◆◆◆◇◇◆◆◆◆◇◆◆◇◆◆◆◆◇◇◆◆◇◇◇◇
◆◆◆◇◇◇◇◆◆◇◇◇◇◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◇◇◆◆◆◇◇◇◆◆◆◇◆◆◇◆◆◆◇◇◇◆◆◇◇◇◇
◆◆◇◇◇◇◆◆◆◇◇◇◆◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◇◇◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◇◇◇
◆◆◇◇◇◇◇◇◇◇◇◇◆◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◇◇◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◇◇◇
◆◆◇◇◇◇◇◇◇◇◇◆◆◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◆◆◇◇◇◇◇◇◇◇◇◇◇◇◇
◆◆◇◇◇◆◆◇◇◇◆◆◆◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◆◆◇◇◇◇◇◇◇◇◇◇◇◇◇
◆◆◆◆◆◆◇◇◇◆◆◆◆◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◇◇◇◆◆◆◆◆◆◆◆◆◆◆◇◇◇◇◇◇◆◆◆◇◇◇◇
◆◆◆◆◆◇◇◇◇◆◆◆◆◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◇◇◇◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◇◇◇◇
◆◆◆◆◇◇◇◇◆◆◇◇◇◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◇◇◇◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◇◇◇◇
◆◆◆◇◇◇◇◇◇◇◇◇◇◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◆◆◇◇◇◇◇◇◇◇◇◇◇◇◇
◆◆◇◇◇◇◇◇◇◇◇◇◇◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◆◆◆◆◇◇◇◇◇◇◇◇◆◆◇◇◇◇◇◇◇◇◆◆◆◆◇
◆◆◆◇◇◇◇◇◆◆◆◆◆◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◇
◆◆◆◆◆◆◆◆◆◆◆◆◇◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◇
◆◆◆◆◆◆◆◆◇◇◇◇◇◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◇◇◆◆◆◇◇◇◇◇◇◇◇◇◇◆◆◇◇◇◇◆◆◇◇◇◇
◆◆◆◇◇◇◇◇◇◇◇◇◇◆◆◆◆◆◇◇◆◆◆◆◆◆◆◆◆   ◇◇◇◇◆◆◆◇◇◇◆◆◆◇◇◇◆◆◆◇◇◇◆◆◆◆◇◇◇
◆◆◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◆◆◆   ◇◇◇◇◆◆◆◇◇◇◆◆◆◇◇◇◆◆◆◆◇◇◇◆◆◆◇◇◇
◆◆◆◇◇◇◇◇◆◆◆◆◇◇◇◇◇◇◇◇◇◇◇◇◇◇◆◆◆   ◇◇◇◆◆◆◇◇◇◇◆◆◆◇◇◇◆◆◆◆◇◇◇◆◆◆◆◇◇
◆◆◆◇◇◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆   ◇◇◇◆◆◆◇◇◇◇◆◆◆◆◇◇◇◆◆◆◇◇◇◆◆◆◆◇◇
◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆   ◇◇◇◆◆◆◇◇◇◇◆◆◆◆◇◇◇◆◆◇◇◇◇◇◆◆◇◇◇
◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆   ◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇◇",
"welcome2" => "                            　　　　　◆◆◆◆　　　　　　　　　　　　　◆◆◆　　　　　
                            　　　　　◆◆◆◆　　　　　　　　　　　　　◆◆◆　　　　　
                            　　　　　◆◆◆　　　　　　　　　　　　　　◆◆◆　　　　　
                            　　　　　　◆◆　　◆◆　　　　　　　　　　◆◆◆　　　　　
                            　　　　　　◆◆　　◆◆◆◆◆◆◆◆　　　　◆◆　　　　　　
                            　　　◆◆　◆◆　◆◆◆◆◆◆◆◆　　　　　◆◆　　　　　　
                            　　◆◆◆◆◆◆◆◆　　　　◆◆◆◆◆◆◆◆◆◆◆◆◆　　　
                            　　◆◆◆◆◆◆◆◆　　　　◆◆◆◆◆◆◆◆◆◆◆◆◆　　　
                            　　　　　◆◆◆　　　◆◆　◆◆◆◆　　　　◆◆　　　　　　
                            　　　　　◆◆◆　　◆◆◆　◆◆◆　　　　　◆◆　　　　　　
                            　　　　　◆◆◆◆　◆◆◆◆◆◆◆　◆◆　　◆◆　　　　　　
                            　　　　◆◆◆◆◆◆　◆◆◆◆◆　◆◆◆　　◆◆　　　　　　
                            　　　　◆◆◆◆◆◆◆　◆◆◆◆　◆◆◆◆　◆◆　　　　　　
                            　　　　◆◆◆◆◆◆◆　◆◆◆◆　　◆◆◆　◆◆　　　　　　
                            　　　◆◆◆◆◆◆◆◆◆◆◆◆◆◆　◆◆◆◆◆◆　　　　　　
                            　　◆◆◆◆◆◆　◆◆　◆◆◆◆◆　　◆◆◆◆◆　　　　　　
                            　　◆◆◆◆◆◆　　　◆◆◆◆◆◆◆　◆◆◆◆◆　　　　　　
                            　　◆◆◆　◆◆　　　◆◆◆　◆◆◆　　　　◆◆　　　　　　
                            　　　◆　　◆◆　　◆◆◆◆　◆◆◆◆　　　◆◆　　　　　　
                            　　　　　　◆◆　◆◆◆◆　　　◆◆◆　　　◆◆　　　　　　
                            　　　　　　◆◆◆◆◆◆　　　　◆　　　　　◆◆　　　　　　
                            　　　　　◆◆◆　◆◆◆　　　　　　　　　　◆◆　　　　　　
                            　　　　　◆◆◆　　　　　　　　　　　◆◆◆◆◆　　　　　　
                            　　　　　◆◆◆　　　　　　　　　　　◆◆◆◆◆　　　　　　
                            　　　　　◆◆◆　　　　　　　　　　　　◆◆◆◆　",
"menu" => "\"
                                             这里是红黑树教程与实验平台

                                      你可以在这里任意操作，不信你再不懂红黑树！

******************************************************操作指南*********************************************************
                      插入操作:ins [结点名（可省）] [结点值]    删除操作:del [结点1值] [结点2值] ...  
        连续插入操作:insname [结点1名] [结点1值] [结点2名] [结点2值] ...       insvalue [结点1值] [结点1名]           
         查看上一步具体操作流程:looklast    显示操作记录:viewinput  隐藏操作记录:hideinput    退出:exit

*****************************************************当前红黑树:********************************************************

\#{$rbt.draw}
\#{\"*\"*(56-$infol/2)}命令台[\#{$info}]\#{\"*\"*(56-$infol+$infol/2)}
\"","log" => "\"
                                               这里是红黑树操作日志记录

                              你可以在这里看到之前操作的整个具体过程，帮你一步步分析红黑树运作机制

******************************************************操作指南**********************************************************
            上一页:pgup     下一页:pgdn     转到最后:looklast    页面跳转:jump [第几页]     返回控制台:return

\#{\"*\"*(55-(($logpage+1).to_s.length+($operation.length).to_s.length)/2)}第\#{$logpage+1}页，共\#{$operation.length}页\#{\"*\"*(55-(($logpage+1).to_s.length+($operation.length).to_s.length+1)/2)}
\""
}
puts Show["welcome1"]
sleep (0.6)
system "cls"
puts Show["welcome2"]
sleep (0.4)
system "cls"
loop { 
    system "cls"
    case $state
    when 0
        puts eval(Show["menu"])
        if $viewinput
            puts $input
        end
        $s=gets
        puts "操作中..."
        i=$s.chomp.split
        if i[0]=="ins"
            if i.length==2
                if i[1].to_i.to_s != i[1]
                    $info="错误：ins结点值参数要是整数哦"
                    $infol=29
                elsif 8>i[1].length
                    $rbt.add(i[1].to_i)
                    $input<<$s
                    $info="插入成功！等待输入"
                    $infol=18
                else
                    $info="错误：老哥你的值超范围了我显示不下，咱能换一个-999999~9999999的数不？"
                    $infol=67
                end
            elsif i.length==3
                if i[2].to_i.to_s!=i[2]
                    $info="错误：ins结点值参数要是整数哦"
                    $infol=29
                elsif 8>i[2].length+i[1].length
                    $rbt.add(i[2].to_i,i[1])
                    $input<<$s
                    $info="插入成功！等待输入"
                    $infol=18
                else
                    $info="错误：老哥你的名和值太长了我显示不下，需要名和值长度加起来不大于7"
                    $infol=65
                end
            else
                $info="错误：ins无参数或参数多于2ge"
                $infol=28
            end
        elsif i[0]=="insvalue"
            if i[1..].map{|e|e.to_i.to_s} != i[1..]
                $info="错误：insvalue参数要是整数哦"
                $infol=28
            elsif i[1..].map{|e|e.length}.max>7
                $info="错误：老哥你有的值超范围了我显示不下，咱能换成-999999~9999999的数不？"
                $infol=67
            else
            i[1..].each { |e| 
                $rbt.add(e.to_i)
            }
            $input<<$s
            $info="插入成功！等待输入"
            $infol=18
            end
        elsif i[0]=="insname"
            if i.length[0]==0
                $info="错误：insname参数个数应为偶数"
                $infol=29
            elsif (1..i.length/2).map{|e|i[e*2].to_i.to_s} != (1..i.length/2).map{|e|i[e*2]}
                $info="错误：insname结点值参数要是整数哦"
                $infol=33
            elsif (1..i.length/2).map{|e|i[e*2].length+i[e*2-1].length}.max>7
                $info="错误：老哥你有的名和值太长了我显示不下，需要名和值长度加起来不大于7"
                $infol=67
            else
                (1..i.length/2).each { |e| 
                    $rbt.add(i[e*2].to_i,i[e*2-1])
                }
                $input<<$s
                $info="插入成功！等待输入"
                $infol=18
            end
        elsif i[0]=="del"
            if i.length ==1
                $info="错误：删除啥？我没看清"
                $infol=22
            elsif i[1..].map { |e| e.to_i.to_s } !=i[1..]
                $info="错误：del参数要都是整数哦"
                $infol=25
            elsif !(i[1..].map { |e|$rbt.find(e.to_i)}.inject{|a,b|a&&b})
                $info="错误：并没有找到所有值"
                $infol=22
            elsif i.uniq.length != i.length
                $info="错误：删除不能有相同的值"
                $infol=24
            else
                $input<<$s
                i[1..].each { |e|$rbt.del(e.to_i)  }
                $info="删除成功！等待输入"
                $infol=18
            end
        elsif i[0]=="viewinput"
            $viewinput=true
        elsif i[0]=="hideinput"
            $viewinput=false
        elsif i[0]=="looklast"
            $logpage=$operation.length-1
            $state=1
            $info="以上是第#{$logpage+1}页的操作记录，接下来要干什么？[等待输入]："
        elsif i[0]=="exit"
            puts "拜拜！"
            break
        else
            $info="错误：不识别此命令"
            $infol=18
        end
    when 1
        puts eval(Show["log"])
        if $logpage>=0
            puts $operation[$logpage]
        else
            puts "\n\n                                                   暂时还没有操作记录"
        end
        print "\n\n",$info
        $s=gets
        puts "操作中..."
        i=$s.chomp.split
        if i[0]=="looklast"
            $logpage=$operation.length-1
            $info="以上是第#{$logpage+1}页的操作记录，接下来要干什么？[等待输入]："
        elsif i[0]=="pgdn"
            if $logpage==$operation.length-1
                $info="这已经是第#{$logpage+1}页，最后一页了！[等待输入]："
            else
                $logpage+=1
                $info="以上是第#{$logpage+1}页的操作记录，接下来要干什么？[等待输入]："
            end
        elsif i[0]=="pgup"
            if $logpage==0
                $info="这已经是第1页了![等待输入]："
            else
                $logpage-=1
                $info="以上是第#{$logpage+1}页的操作记录，接下来要干什么？[等待输入]："
            end
        elsif i[0]=="jump"
            if i.length != 2
                $info="错误：jump应有且只有一个参数[等待输入]："
            elsif i[1].to_i.to_s!=i[1]
                $info="错误：jump参数应为整数[等待输入]："
            elsif i[1].to_i<1 or i[1].to_i>$operation.length
                $info="错误：jump参数超出范围（1——#{$operation.length}）[等待输入]："
            else
                $logpage=i[1].to_i-1
                $info="以上是第#{$logpage+1}页的操作记录，接下来要干什么？[等待输入]："
            end
        elsif i[0]=="return"
            $state=0
            $info="等待输入"
            $infol=8
        else
            $info="错误：不识别此命令[等待输入]："
        end
    end

}
rescue Exception => e
    puts "你给我整崩溃了！这是提示信息:"
    puts $ope
    puts e.backtrace.inspect
    puts e.message
end
system "pause"