//
//  ColorTagsView.swift
//  ToDoList-SwiftData-SwiftUI
//
//  Created by Jayaram G on 24/11/26.
//
import SwiftUI

struct ColorTagsView: View {

    @Binding var selectedTags: Set<Tag>
    var toggleTag: (Tag) -> Void
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(Tag.allCases, id: \.self) { tag in
                    Button {
                        //TODO: Toggle
                        toggleTag(tag)
                    } label: {
                        Text(tag.rawValue.capitalized).padding(.horizontal, 10).padding(.vertical, 10).background(selectedTags.contains(tag) ? tag.color.opacity(0.8) : .gray.opacity(0.3)).foregroundStyle(.white).clipShape(Capsule())
                    }
                    
                }
            }
        }.scrollIndicators(.hidden)
        
    }
}
