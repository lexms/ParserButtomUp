// This program is develop and Compile using VS Code and Free Pascal Compiler version 3.0.4 [2017/10/06] for i386

{
    10116370 Alexander M S
}
Program ParserButtomUp;

uses crt, wincrt, sysutils;

const
    maxStack = 50;
    maxString = 50;


type
    arrayStack = array[1..maxStack] of string;
    arrayTable = array[0..9, 0..5] of string; //y,x
    
var
    data:arrayStack;
    parser_table:arrayTable;

    input_data,input_string:string;
    top, rule_number:integer;

    recent_action:string;

    i,z:integer;

//STACK HANDLING BEGIN
procedure create_stack(var top:integer);
begin
    top := 0;
end;

function empty_stack(var top:integer):boolean;
begin
    empty_stack := top = 0;
end;

function full_stack(var top:integer):boolean;
begin
    full_stack := top = maxStack;
end;

procedure push_data(var top:integer; var input_data:string);
begin
    if (not full_stack(top)) then
    begin
        data[top+1] := input_data;
        top := top + 1;
    end
    else
    begin
        write('<STACK FULL>');
    end;
end;

procedure pop_data(var top:integer; var input_data:string);
begin
    if (not empty_stack(top)) then
    begin
        input_data := data[top];
        top := top - 1;
    end
    else
    begin
        write('<STACK EMPTY>');
    end;
end;

procedure show_stack(var top:integer);
var
    i:integer;

begin
    if (not empty_stack(top)) then
    begin
        
        {reverse print 
        for i := tmp downto 0 do
        begin
            write(data[tmp]);
            tmp := tmp - 1;
        end; }

        for i:= 0 to top do
        begin
            write(data[i]:0,' ');
        end;
    end
    else
    begin
        write('<STACK EMPTY>');
    end;
end;

function print_stack:string;
var
    i:integer;
begin
    print_stack:='';
    if (not empty_stack(top)) then
    begin
        for i:= 0 to top do
        begin
            print_stack:=print_stack+(data[i])+' ';
        end;
    end
    else
    begin
        write('<STACK EMPTY>');
    end;


end;
//STACK HANDLING END

procedure createParserTable;
var
    x,y:integer;
begin
    //y , x
    parser_table[0,0]:='io';
    parser_table[0,1]:='s3';
    parser_table[0,2]:='s4';
    parser_table[0,3]:='';
    parser_table[0,4]:='1';
    parser_table[0,5]:='2';
    
    parser_table[1,0]:='i1';
    parser_table[1,1]:='';
    parser_table[1,2]:='';
    parser_table[1,3]:='ACC';
    parser_table[1,4]:='';
    parser_table[1,5]:='';

    parser_table[2,0]:='i2';
    parser_table[2,1]:='s6';
    parser_table[2,2]:='s7';
    parser_table[2,3]:='';
    parser_table[2,4]:='';
    parser_table[2,5]:='5';

    parser_table[3,0]:='i3';
    parser_table[3,1]:='s3';
    parser_table[3,2]:='s4';
    parser_table[3,3]:='';
    parser_table[3,4]:='';
    parser_table[3,5]:='8';

    parser_table[4,0]:='i4';
    parser_table[4,1]:='r3';
    parser_table[4,2]:='r3';
    parser_table[4,3]:='';
    parser_table[4,4]:='';
    parser_table[4,5]:='';

    parser_table[5,0]:='i5';
    parser_table[5,1]:='';
    parser_table[5,2]:='';
    parser_table[5,3]:='r1';
    parser_table[5,4]:='';
    parser_table[5,5]:='';

    parser_table[6,0]:='i6';
    parser_table[6,1]:='s6';
    parser_table[6,2]:='s7';
    parser_table[6,3]:='';
    parser_table[6,4]:='';
    parser_table[6,5]:='9';

    parser_table[7,0]:='i7';
    parser_table[7,1]:='';
    parser_table[7,2]:='';
    parser_table[7,3]:='r3';
    parser_table[7,4]:='';
    parser_table[7,5]:='';

    parser_table[8,0]:='i8';
    parser_table[8,1]:='r2';
    parser_table[8,2]:='r2';
    parser_table[8,3]:='';
    parser_table[8,4]:='';
    parser_table[8,5]:='';

    parser_table[9,0]:='i9';
    parser_table[9,1]:='';
    parser_table[9,2]:='';
    parser_table[9,3]:='r2';
    parser_table[9,4]:='';
    parser_table[9,5]:='';

    writeln('Parser Table');
    writeln('STAT|  c  |  d  |  $  | <S> | <C> |');
    writeln('===================================');
    for y:=0 to 9 do
    begin
        for x:=0 to 5 do
            write(parser_table[y,x]:3,' | ');
        writeln;
    end;
    writeln('===================================');
    
end;

//rule module
procedure reduce_rule(var rule_number:integer);
var
    i:integer;
begin
    case rule_number of
        //<S> ::= <C> <C>
        1: 
        begin
            for i:= top downto 0 do
            begin
                if data[i]='<C>' then
                begin
                    pop_data(top,input_data); //pop <C>
                    pop_data(top,input_data); //pop number
                end;    
            end;
            input_data:='<S>';
            push_data(top,input_data);
        end;
        //<C> ::= c <C>
        2:
        begin
            for i:= top downto 0 do
            begin
                if (data[i]='c') and (data[i+2]='<C>') then
                begin
                    pop_data(top,input_data);//pop <C>
                    pop_data(top,input_data);//pop number
                    pop_data(top,input_data);//pop c
                    pop_data(top,input_data);//pop number
                end;
            end;
            input_data:='<C>';
            push_data(top,input_data);
        end;
        //<C> ::= d
        3:
        begin
            for i:= top downto 0 do
            begin
                if data[i]='d' then
                begin
                    pop_data(top,input_data); //pop d
                    pop_data(top,input_data); //pop number
                end;    
            end;
            input_data:='<C>';
            push_data(top,input_data);
        end;
    else
        begin
            writeln('No Rule Selected');
            readln;
        end;        
    end;//end case

end;

function find_action(input_string:string):string;
var
    x,y:integer;

begin
    if (input_string[1]='c') then
        x:=1
    else
    if (input_string[1]='d') then
        x:=2
    else
    if (input_string[1]='$') then
        x:=3
    else
    begin
        find_action:='not accepted';
        write('Not Accepted Action');
        readln;
    end;

    //data = stack
    y:=StrToInt(data[top]);
    find_action:=parser_table[y,x];

    //if found no action in parser table
    if (find_action='') then
    begin
        find_action:='not accepted';
        write('no action found on parser table');
        readln;
        exit;
    end;

end;

function find_shift_number(recent_action:string):string;
begin
    if (recent_action[1]='s') then
        find_shift_number:=recent_action[2]
    else
    begin
        find_shift_number:='';
        writeln('Error in find_shift_number, recent action:', recent_action, '*');
        readln;
    end;
end;

procedure delete_left_most_string;
begin
    if (recent_action[1]='s') then
    begin
        for i:=1 to (length(input_string)) do
        begin
            input_string[i]:=input_string[i+1]
        end;

        input_string[length(input_string)]:=' ';
    end
    else
    begin
        writeln('Error in delete_left_most_string');
        readln;
    end;
end;

function find_number_from_combination:string;
var
    x,y:integer;
begin
    if (data[top]='<S>') then
        x:=4
    else
    if (data[top]='<C>') then
        x:=5
    else
    begin
        find_number_from_combination:='not accepted';
        write('Not Accepted Rule');
        readln;
    end;
    y:=StrToInt(data[top-1]);
    find_number_from_combination:=parser_table[y,x];
end;

procedure print_grammar;
begin  
    writeln('');
    writeln('GRAMMAR');
    writeln('<S> ::= <C> <C>');
    writeln('<C> ::= c <C>');
    writeln('<C> ::= d');
    writeln('');
end;


//MAIN PROGRAM
begin
    createParserTable;
    print_grammar;

    //init STACK with 0   
    create_stack(top);
    input_data:='0';
    push_data(top,input_data);

    //init STRING
    //input_string:='cdd$';

    writeln('===Input String===');writeln('e.g:cdd');
    writeln('------------------');
    write(':');readln(input_string);
    
    input_string:=input_string+'$';
    {
        data = stack
        input_string = string
    }
    writeln('');
    writeln('');
    writeln('STACK':30,'|', 'STRING':10,'|', 'ACTION':10,'|');

    i:=0;
    z:=0;
    repeat
        write(print_stack:30,'|');
        write(input_string:10,'|');

        recent_action:=find_action(input_string);
        writeln(recent_action:10,'|');

    //IF Shift
    if (recent_action[1]='s') then 
    begin
    // push stack
        //1.) push terminal 
        input_data:=input_string[1];
        push_data(top,input_data);

        //delete left most string
        delete_left_most_string;

        //2.) push number
        input_data:=find_shift_number(recent_action);
        push_data(top,input_data); 
    end;

    //IF Reduce
    if (recent_action[1]='r') then
    begin
        rule_number:=StrToInt(recent_action[2]);
        reduce_rule(rule_number);
        //push  number and non terminal combination
        input_data:=find_number_from_combination();
        push_data(top,input_data); 
    end;
        z:=z+1;

    
    until (recent_action='ACC');
  

    readln;
end.