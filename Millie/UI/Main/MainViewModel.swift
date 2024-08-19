//
//  MainViewModel.swift
//  Millie
//
//  Created by dlwlrma on 8/19/24.
//

import Combine
import CoreData
import Foundation
import UIKit

class MainViewModel {
    private var newsService = NewsService()
    private var cancellables = Set<AnyCancellable>()

    var diffableDataSource: NewsDiffableDataSource!
    var snapshot = NSDiffableDataSourceSnapshot<String?, News>()

    init() {
        getNewsFromApi()
    }

    private func getNewsFromApi() {
        newsService.getHeadlines()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)

                    let entities = self.getNewsFromDatabase()
                    let news = entities.map {
                        News(author: $0.author,
                             title: $0.title,
                             url: $0.url,
                             publishedAt: $0.publishedAt)
                    }

                    self.updateDataSource(news: news)
                    break
                }
            }, receiveValue: { response in
                let news = response.articles.map {
                    News(author: $0.author,
                         title: $0.title,
                         url: $0.url,
                         publishedAt: $0.publishedAt)
                }

                self.insertNewsToDatabase(news: news)
                self.updateDataSource(news: news)
            })
            .store(in: &cancellables)
    }

    private func updateDataSource(news: [News]) {
        snapshot.deleteAllItems()
        snapshot.appendSections([""])
        
        if news.isEmpty {
            diffableDataSource.apply(snapshot, animatingDifferences: true)
        } else {
            snapshot.appendItems(news)
            diffableDataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    private func getNewsFromDatabase() -> [News] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }

        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Headline>(entityName: String(describing: Headline.self))
        let fetchResult = try? managedObjectContext.fetch(fetchRequest)
        
        return fetchResult?.map {
            News(author: $0.author,
                 title: $0.title,
                 description: $0.desc,
                 url: $0.url,
                 urlToImage: $0.urlToImage,
                 publishedAt: $0.publishedAt,
                 content: $0.content)
        } ?? []
    }

    private func insertNewsToDatabase(news: [News]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedObjectContext = appDelegate.persistentContainer.viewContext
        news.forEach {
            if let entity = NSEntityDescription.entity(forEntityName: "Headline", in: managedObjectContext) {
                let managedObject = NSManagedObject(entity: entity, insertInto: managedObjectContext)

                managedObject.setValue($0.author, forKey: "author")
                managedObject.setValue($0.title, forKey: "title")
                managedObject.setValue($0.description, forKey: "desc")
                managedObject.setValue($0.url, forKey: "url")
                managedObject.setValue($0.urlToImage, forKey: "urlToImage")
                managedObject.setValue($0.publishedAt, forKey: "publishedAt")
                managedObject.setValue($0.content, forKey: "content")

                do {
                    try managedObjectContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                return
            }
        }
    }
}
