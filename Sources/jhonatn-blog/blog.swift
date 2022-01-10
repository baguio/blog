import Publish
import Plot
import Foundation
import TokamakPublish

struct Blog: Website {
    enum SectionID: String, WebsiteSectionID {
        case posts
    }
    
    struct ItemMetadata: WebsiteItemMetadata {}
    
    var url = URL(string: "https://jhona.tn/blog")!
    var name = "jhona.tn: Blog"
    var description = "A tech experimentation blog"
    var language: Language { .english }
    var imagePath: Publish.Path? { nil }
}

let secondaryTextColor = Color(0x8A8A8A)
let backgroundColor = Color(0xEEEEEE)

extension Theme where Site == Blog {
    static var blog: Self {
        Theme(htmlFactory: BlogHTMLFactory())
    }
    
    struct BlogHTMLFactory: TokamakHTMLFactory {
        func makeIndexView(for index: Index, context: PublishingContext<Site>) throws -> some View {
            Header(context: context)
            VStack(alignment: .leading) {
                Text(context.site.description)
                    .font(.caption)
                    .padding(.bottom)
                ItemList(
                    items: context.allItems(sortedBy: \.date, order: .descending),
                    site: context.site
                )
            }
            .frame(idealWidth: 820, maxWidth: 820)
            .padding(.vertical, 40)
            Footer(site: context.site)
        }
        
        func makeSectionView(for _: Publish.Section<Site>, context: PublishingContext<Site>) throws -> some View {
            EmptyView()
        }
        
        func makeItemView(for item: Item<Site>, context: PublishingContext<Site>) throws -> some View {
            Header(context: context)
            VStack(alignment: .leading) {
                item.body
                //              Text("Tagged with: ")
                TagList(item: item, site: context.site)
            }
            .frame(idealWidth: 820, maxWidth: 820)
            .padding(.vertical, 40)
            Footer(site: context.site)
        }
        
        func makePageView(for page: Page, context: PublishingContext<Site>) throws -> some View {
            Header(context: context)
            VStack(alignment: .leading) {
                page.body
            }
            .frame(idealWidth: 820, maxWidth: 820)
            .padding(.vertical, 40)
            Footer(site: context.site)
        }
        
        func makeTagListView(for page: TagListPage, context: PublishingContext<Site>) throws -> some View {
            Header(context: context)
            VStack(alignment: .leading) {
                Text("Browse all tags")
                    .font(.headline)
                HStack {
                    ForEach(page.tags.sorted()) { tag in
                        Tag(tag: tag, site: context.site)
                    }
                }
            }
            .frame(idealWidth: 820, maxWidth: 820)
            .padding(.vertical, 40)
            Footer(site: context.site)
        }
        
        func makeTagDetailsView(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> some View {
            Header(context: context)
            VStack(alignment: .leading) {
                HStack {
                    Text("Tagged with")
                        .padding(.trailing)
                    Tag(tag: page.tag, site: context.site)
                }
                .font(.headline)
                Link(
                    "Browse all tags",
                    destination: context.site.generateURL(for: context.site.tagListPath.absoluteString)
                )
                ItemList(
                    items: context.items(
                        taggedWith: page.tag,
                        sortedBy: \.date,
                        order: .descending
                    ),
                    site: context.site
                )
            }
            .frame(idealWidth: 820, maxWidth: 820)
            .padding(.vertical, 40)
            Footer(site: context.site)
        }
    }
    
    
    struct ItemList: View {
        let items: [Item<Site>]
        let site: Site
        
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(items) { item in
                    VStack(alignment: .leading) {
                        Link(destination: site.generateURL(for: item.path.absoluteString)) {
                            Text(item.title)
                                .font(.headline)
                        }
                        Text(item.description)
                            .font(.caption)
                    }
                    .padding(20)
                    .background(backgroundColor)
                    .cornerRadius(8)
                }
            }
        }
    }
    
    struct TagList: View {
        let item: Item<Site>
        let site: Site
        
        var body: some View {
            HStack(spacing: 5) {
                ForEach(item.tags) { tag in
                    Tag(tag: tag, site: site)
                }
            }
        }
    }
    
    struct Header: View {
        let context: PublishingContext<Site>
        
        var body: some View {
            Link(
                context.site.name,
                destination: context.site.url
            )
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(secondaryTextColor)
                .padding(.horizontal, 40)
                .padding(.vertical, 30)
                .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
    
    struct Footer: View {
        let site: Site
        var body: some View {
            HStack {
                Text("Generated using")
                    .padding(0)
                Link(destination: URL(string: "https://github.com/johnsundell/publish")!) {
                    Text("Publish")
                        .underline()
                }
                Text("and")
                    .padding(0)
                Link(destination: URL(string: "https://github.com/TokamakUI/Tokamak")!) {
                    Text("Tokamak")
                        .underline()
                }
            }
            .foregroundColor(secondaryTextColor)
        }
    }
    
    struct Tag: View {
        let tag: Publish.Tag
        let site: Site
        
        var body: some View {
            Link(destination: site.generateURL(for: site.path(for: tag).absoluteString)) {
                Text(tag.string)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
    }
}

extension Website {
    func generateURL(for path: String) -> URL {
        url.appendingPathComponent(path)
    }
}
