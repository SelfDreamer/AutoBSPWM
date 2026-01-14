import requests

def get_auto_keyboard_layout(country_code):
    try:
        url = f"https://restcountries.com/v3.1/alpha/{country_code}"
        response = requests.get(url, timeout=5)
        response.raise_for_status()
        
        data = response.json()[0]
        
        region = data.get('region', '')
        languages = data.get('languages', {}) 
        
        # print(f"[*] Datos API: Región={region}, Idiomas={list(languages.keys())}")

        if 'spa' in languages:
            if region == 'Americas':
                return 'latam'  
            else:
                return 'es'    

        if 'por' in languages:
            if region == 'Americas':
                return 'br'    
            else:
                return 'pt'   

        if country_code == 'GB':
            return 'gb'

        return 'us'

    except Exception:
        return 'us'

def main():
   

    my_country = requests.get('https://ipapi.co/json/').json().get('country_code')

    best_layout = get_auto_keyboard_layout(my_country)

    print(best_layout)

if __name__ == "__main__":
    main()
