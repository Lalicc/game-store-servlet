// Login
function login()
{
    username = document.querySelector("#username").value;
    pass = document.querySelector("#password").value;
    var xmlhttp = new XMLHttpRequest();
    greska="";

    if(!testUserPass(username) || !testUserPass(pass)) greska = "Neispravni podaci! ";

    if(greska=="")
    {
        xmlhttp.onreadystatechange = function()
        {
            if(this.readyState == 4 && this.status == 200)
            {
                response = JSON.parse(this.responseText);
                const d = new Date();
                d.setTime(d.getTime() + 86401000);
                c = document.cookie.split(";");
                for(i=0;i<c.length;i++)
                {
                    document.cookie = c[i] + "=; expires="+ new Date(0).toUTCString();
                }

                document.cookie = `sessid=${response['sessid']}; expires=${d.toUTCString()};`;
                window.location = 'http://localhost:8000/cgi-bin/index.py';

            }
            else
            {
                document.querySelector("#errorLog").innerHTML="Korisnik ne postoji";
            }
        }
        xmlhttp.open("GET",`../cgi-bin/ajax.py?log_in=1&username=${username}&password=${pass}`,true);
        xmlhttp.send();
    }
    else
    {
        document.querySelector("#errorLog").innerHTML=greska;
    }
}


function register()
{
    username = document.querySelector("#username").value;
    password = document.querySelector("#password").value;
    email = document.querySelector("#email").value;
    gamename = document.querySelector("#gamename").value;
    first_name = document.querySelector("#first_name").value;
    last_name = document.querySelector("#last_name").value;
    greska="";
	if(first_name.length == 0 || last_name.length == 0) greska = "Unesite podatke";
	else if (!testEmail(email))
		greska = "Neispravna email adresa.";
	else if (!testUserPass(password) || !testUserPass(username) || !testUserPass(gamename))
		greska = "Unesite ispravne podatke.";

    if(greska=="")
    {
        reg = {}
        reg['first_name'] = first_name
        reg['last_name'] = last_name
        reg['username'] = username
        reg['password'] = password
        reg['email'] = email
        reg['gamename'] = gamename
        reg = JSON.stringify(reg);

        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function()
        {
            if(this.readyState == 4 && this.status == 200)
            {
                response = JSON.parse(this.responseText);
                if (response['register']=="True")
                {
                    window.location = 'http://localhost:8000/cgi-bin/login.py';
                }
            }
        }
        xmlhttp.open("GET",`../cgi-bin/ajax.py?reg=1&info=${reg}`,true);
        xmlhttp.send();
    }
    else
    {
        document.querySelector("#err").innerHTML = greska;
    }

}

//REGEX
function testEmail(x)
{
	var r = new RegExp(/^[A-Za-z0-9\.\-\_]{5,}\@[a-z]{2,10}\.[a-z]{1,3}$/);
	if(r.test(x))
		return true;
	return false;
}

function testUserPass(x)
{
	var r = new RegExp(/^[A-Za-z0-9]{3,15}$/);
	if(r.test(x))
		return true;
	return false;
}

function logOut()
{
    c=getCookieValue("sessid");
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function()
    {
        if(this.readyState == 4 && this.status == 200)
        {
            response = JSON.parse(this.responseText);
            if(response['izloguj'] == 1)
            {
                document.cookie = "sessid=; expires=Thu, 01 Jan 1970 00:00:00 UTC;";
                window.location = 'http://localhost:8000/cgi-bin/login.py';
            }
        }
    }
    xmlhttp.open("GET",`../cgi-bin/ajax.py?log_out=1&sessid=${c}`,true);
    xmlhttp.send();
}

function profile()
{
    username = document.querySelector("#username");
    first_name = document.querySelector("#first_name");
    last_name = document.querySelector("#last_name");
    balance = document.querySelector("#balance");
    email = document.querySelector("#email");
    gamename = document.querySelector("#gamename");
    c=getCookieValue("sessid");
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function()
    {
        if(this.readyState == 4 && this.status == 200)
        {
            response = JSON.parse(this.responseText);
            if (response)
            {
                username.innerHTML = response['username'];
                first_name.innerHTML = response['first_name'];
                last_name.innerHTML = response['last_name'];
                balance.innerHTML = `$${parseFloat(response['balance']).toFixed(2)}`;
                email.innerHTML = response['email'];
                gamename.innerHTML = response['gamename'];

            }
        }
        else
        {
            document.querySelector("#username").innerHTML="Greska";
        }
    }

    xmlhttp.open("GET",`../cgi-bin/ajax.py?dajPodatke=1&sessid=${c}`,true);
    xmlhttp.send();

}

function getCookieValue(cookieName) {
    var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = cookies[i].trim();
            if (cookie.indexOf(cookieName + '=') === 0) {
                return cookie.substring(cookieName.length + 1);
        }
    }
    return null;
}

function initIndex()
{
    setGamesForSale();
    setSessionStorage();
}

function setGamesForSale()
{
    table = document.querySelector(".game-cards");
    c=getCookieValue("sessid");
    is = "";
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function()
    {
        if(this.readyState == 4 && this.status == 200)
        {
            response = JSON.parse(this.responseText);
            for(game of response['allgames'])
            {
                is+=`
                <div class="game-card">
                    <img class="cardPicture" src="../images/${game['image']}" alt="">
                    <h2>${game['name']}</h2>
                    <p>Price: $${game['price']}</p>
                    <button class="dugmeDodaj" onclick="ubaciuKorpu('${game['name']}')"">Add to cart</button>
                </div>                
                `;
            }
            table.innerHTML+=is;
        }
        else
        {
            console.log("greska ")
        }
    }

    xmlhttp.open("GET",`../cgi-bin/ajax.py?allGames=1`,true);
    xmlhttp.send();
}

function games()
{

    ul = document.querySelector("#gameList");
    c=getCookieValue("sessid");
    is = "";
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function()
    {
        if(this.readyState == 4 && this.status == 200)
        {
            response = JSON.parse(this.responseText);
            for(game of response['games'])
            {
                is+=`<li class="item" onclick="showGameDetails( '${game['name']}' )" > ${game['name']} </li>`;
            }
            ul.innerHTML+=is;
        }
        else
        {
            console.log("greska ")
        }
    }

    xmlhttp.open("GET",`../cgi-bin/ajax.py?dajGames=1&sessid=${c}`,true);
    xmlhttp.send();
}

function showGameDetails(game) {
    var gameDescription = "";

    title=document.querySelector("#title");
    desc=document.querySelector("#game-description");
    image=document.querySelector("#image");

    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function()
    {
        if(this.readyState == 4 && this.status == 200)
        {
            response = JSON.parse(this.responseText);
            if (response)
            {
                title.innerHTML = `${game}`;
                desc.innerHTML = response['description'];
                image.innerHTML = `<img class="pic" src = ../images/${response['image']}>`;

            }
        }
    }
    xmlhttp.open("GET",`../cgi-bin/ajax.py?oneGame=1&game=${game}`,true);
    xmlhttp.send();


    document.getElementById("game-description").innerText = gameDescription;
}

function check()
{
    if(getCookieValue('sessid')){
        if(getCookieValue('sessid').length==14)
        {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    window.location = 'http://localhost:8000/cgi-bin/index.py';
                }
            };
            xmlhttp.open("GET", `../cgi-bin/ajax.py?check=1&sessid=${getCookieValue('sesid')}`, true);
            xmlhttp.send();
        }
    }
}

function setSessionStorage()
{
    cart = sessionStorage.getItem('cart');
    if(!cart)
    {
        cart = {gameid:[],name:[], price:[]}
        cart = JSON.stringify(cart);
        sessionStorage.setItem('cart',cart);
        price = {price:0.00}
        price = JSON.stringify(price);
        sessionStorage.setItem('price',price);
    }
}

function insertIntoSession(product)
{
    q = -1;
    cart = sessionStorage.getItem('cart');
    cart = JSON.parse(cart);
    for(let i=0;i<cart['gameid'].length;i++)
    {
        if(cart['gameid'][i]==product['gameid'])
            q = i;
    }
    if(q!=-1)
    {
        console.log("Vec postoji u korpi! ");
    }
    else
    {
        cart['gameid'].push(product['gameid']);
        cart['name'].push(product['name']);
        cart['price'].push(product['price']);
        price = JSON.parse(sessionStorage.getItem('price'));
        price['price'] += product['price'];
        price = JSON.stringify(price);
        sessionStorage.setItem('price',price);
        cart = JSON.stringify(cart);
        sessionStorage.setItem('cart',cart);
        
    }
}

// {'info':[{},{},{}]}
function ubaciuKorpu(game)
{
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function()
    {
        if(this.readyState == 4 && this.status == 200)
        {
            var response = JSON.parse(this.responseText);

            if(response['name'] == game)
            {
                console.log(`Dodao sam igricu ${game} u korpu`);
                insertIntoSession(response);
                prikaziKorpu();
            }
            
        }
    }
    xmlhttp.open("GET",`../cgi-bin/ajax.py?dajgame=1&name=${game}`,true);
    xmlhttp.send();
}

function prikaziKorpu()
{
    cart = JSON.parse(sessionStorage.getItem('cart'));
    table = `<tr><th>Game name</th><th>Price</th></tr>`;
    if(cart['gameid'].length)
    {
        document.querySelector("#oKorpi").innerHTML="Korpa" ;   
        document.querySelector("#listaZaKupovinu").style.display= "";
        document.querySelector("#kupiButton").style.display="" ;
        document.querySelector("#ukupnaCena").style.display="";

    }
    else
    {
        document.querySelector("#oKorpi").innerHTML="Nemate stvari u korpi" ;   
        document.querySelector("#listaZaKupovinu").style.display= "none";
        document.querySelector("#kupiButton").style.display="none" ;
        document.querySelector("#ukupnaCena").style.display="none";
        document.querySelector("#nedovoljno").innerHTML="";
    }
    for(let i=0;i<cart['gameid'].length;i++)
    {
        table+="<tr>";
        table+=`<td>${cart['name'][i]}</td><td>$${cart['price'][i]}</td><td><button id='${cart['gameid'][i]}' onclick='izbaciIzKorpeOG(this)'>Remove item</button></td>`;
        table+="</tr>";
    }
    price = JSON.parse(sessionStorage.getItem('price'));
    document.querySelector("#listaZaKupovinu").innerHTML = table;
    document.querySelector("#ukupnaCena").innerHTML = `Ukupna cena:  $${parseFloat(price['price']).toFixed(2)}`;
}

function removeFromListByIndex(list,index)
{
    new_list = [];
    for(let i=0;i<list.length;i++)
    {
        if(i!=index)
            new_list.push(list[i]);

    }
    return new_list;
}

function izbaciIzKorpeOG(x)
{
    x = x.id;
    pozicija = 0;
    cart = JSON.parse(sessionStorage.getItem('cart'));
    price = JSON.parse(sessionStorage.getItem('price'));
    for(let i=0;i<cart['gameid'].length;i++)
    {
        if(cart['gameid'][i] == x)
            pozicija = i;
    }
    price['price'] -= cart['price'][pozicija];
    cart['gameid'] = removeFromListByIndex(cart['gameid'],pozicija);
    cart['name'] = removeFromListByIndex(cart['name'],pozicija);
    cart['price'] = removeFromListByIndex(cart['price'],pozicija);

    
    console.log(cart);

    cart = JSON.stringify(cart);
    price = JSON.stringify(price);
    sessionStorage.setItem('cart',cart);
    sessionStorage.setItem('price',price);
    prikaziKorpu();

}

function Kupovina()
{
    
    sid = getCookieValue('sessid');
    console.log(sid);
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function()
    {
        if(this.readyState == 4 && this.status == 200)
        {
            response = JSON.parse(this.responseText);
            info = {};
            info['username'] = response['username'];
            info['balance'] = response['balance'];
            info['sessid'] = response['sessid'];
            info = JSON.stringify(info);
            {
                console.log(info);
                cart = sessionStorage.getItem('cart');
                cart = JSON.parse(cart);
                cart = JSON.stringify(cart);
                price = sessionStorage.getItem('price');
                price = JSON.parse(price);
                price = JSON.stringify(price);
                document.getElementById("nedovoljno").innerHTML = "";
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function()
                {
                    if(this.readyState == 4 && this.status == 200)
                    {
                        res = JSON.parse(this.responseText);
                        if(res['PROSO'] == 1)
                        {
                            sessionStorage.removeItem('cart');
                            sessionStorage.removeItem('price'); 
                            setSessionStorage();
                            prikaziKorpu();
                            alert("Uspesno ste kupili zeljene igrice! ");
                        }
                        if(res['PROSO'] == 0)
                        {
                            alert("Nemate dovoljno novca! ");
                        }
                    } 
                }
                xmlhttp.open("GET",`../cgi-bin/ajax.py?buy=1&info=${info}&cart=${cart}`,true);
                xmlhttp.send()                
            }
        }
    }
    xmlhttp.open("GET",`../cgi-bin/ajax.py?buyer=1&sessid=${sid}`,true);
    xmlhttp.send();
}
