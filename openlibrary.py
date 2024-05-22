import requests

def get_book_genre(title):
    url = f'http://openlibrary.org/search.json?title={title}'
    response = requests.get(url)
    data = response.json()

    print(response.json())

    if 'docs' in data and data['docs']:
        book_info = data['docs'][0]
        if 'subject' in book_info:
            return book_info['subject']
        else:
            return "Genre information not available."
    else:
        return "Book not found."
# 
# Example usage
book_title = "Mensagem"
book_isbn = "1781us103089"
genre = get_book_genre(book_title)
print(f"The genre of '{book_title}' is: {genre}")
