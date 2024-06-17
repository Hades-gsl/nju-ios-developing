/*
Package scrape provides a function to parse the coded input string
and return the download url of the corresponding puzzle.

Encoding format: <type(1)><level(1)><vol(2)><book(1-3)>

type: 4: 4x4, 5: 5x5, 6: 6x6

level: 0: (Beginner), 1: (Easy), 2: (Med), 3: (Hard), 4: (Mixed), 5: (No-op)

vol: 01-20

book: 1-100

e.g.: 40011
*/
package scrape

import (
    "github.com/gocolly/colly"
    "strconv"
    "strings"
)

const url = "https://krazydad.com/inkies/"

var c *colly.Collector

var s, ret string

var kv = map[byte]string{
    '0': "(Beginner)",
    '1': "(Easy)",
    '2': "(Med)",
    '3': "(Hard)",
    '4': "(Mixed)",
    '5': "(No-op)",
}

// Parse parses the input coded string and returns the download url
func Parse(in string) string {
    c = colly.NewCollector()

    c.OnHTML("ul[class='inkytypelist'] li", mainPageProcess)
    c.OnHTML("ul[class='puzzle-list']", secondaryPageProcess)
    c.OnHTML("div[class='span12 puzzles-download']", extractDownloadUrl)
    c.OnError(errorHandle)

    s = in

    c.Visit(url)

    return ret
}

func mainPageProcess(e *colly.HTMLElement) {
    title := e.ChildText("h2")
    if title[0] != s[0] {
        return
    }
    
    num, _ := strconv.Atoi(s[2:4])
    cnt := 0

    e.ForEach("a", func(_ int, el *colly.HTMLElement) {
        if el.Text == kv[s[1]] {
            cnt += 1
            if cnt == num {
                c.Visit(url + el.Attr("href"))
            }
        }
    })
}

func secondaryPageProcess(e *colly.HTMLElement) {
    e.ForEach("li", func(_ int, el *colly.HTMLElement) {
        text := strings.Split(strings.TrimSpace(el.Text), " ")[1]
        if text == s[4:] {
            suffix := el.ChildAttr("a", "href")
            c.Visit(strings.ReplaceAll(url+suffix, " ", "%20"))
        }
    })
}

func extractDownloadUrl(e *colly.HTMLElement) {
    ret = e.ChildAttr("a", "href")
}

func errorHandle(r *colly.Response, err error) {
    println("visit", r.Request.URL.String(), "err:", err.Error())
}
